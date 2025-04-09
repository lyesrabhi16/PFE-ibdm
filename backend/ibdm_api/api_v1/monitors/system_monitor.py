# monitor.py
import os
import sys
import json
import platform
import threading
import psutil
import traceback
import uuid
from datetime import datetime

from django.db import connections
from django.conf import settings
from api_v1.env import Env
from redis import Redis

from api_v1.sql import RAW_SQL
from logs.logging import logger

# Path to store status data
STATUS_FILE = settings.STATUS_FILE_PATH

# Flag to control the monitoring loop
running = True

def get_system_info():
    """Get system information"""
    start = datetime.now()
    system_info = {}

    # Get the system information
    system_info["os"] = platform.platform()
    system_info["python_version"] = sys.version
    system_info["django_version"] = settings.VERSION
    system_info["env_mode"] = Env.ENV_MODE
    system_info["debug"] = settings.DEBUG
    system_info["hostname"] = platform.node()
    system_info["cpu_architecture"] = platform.architecture()[0]
    system_info["cpu_model"] = platform.processor()
    system_info["cpu_frequency"] = psutil.cpu_freq().current if psutil.cpu_freq() else None
    # Memory information
    system_info["total_memory"] = psutil.virtual_memory().total
    system_info["available_memory"] = psutil.virtual_memory().available
    system_info["memory_percent_used"] = psutil.virtual_memory().percent

    # CPU information
    system_info["cpu_count"] = psutil.cpu_count(logical=True)
    system_info["cpu_physical_count"] = psutil.cpu_count(logical=False)
    system_info["cpu_percent"] = psutil.cpu_percent(interval=1)

    # Disk information
    disk = psutil.disk_usage('/')
    system_info["total_storage"] = disk.total
    system_info["used_storage"] = disk.used
    system_info["free_storage"] = disk.free
    system_info["disk_percent_used"] = disk.percent
    system_info["disk_io_read_count"] = psutil.disk_io_counters().read_count
    system_info["disk_io_write_count"] = psutil.disk_io_counters().write_count
    system_info["disk_io_read_bytes"] = psutil.disk_io_counters().read_bytes
    system_info["disk_io_write_bytes"] = psutil.disk_io_counters().write_bytes


    # System uptime
    system_info["uptime"] = (datetime.now() - datetime.fromtimestamp(psutil.boot_time())).total_seconds()
    system_info["boot_time"] = datetime.fromtimestamp(psutil.boot_time()).strftime('%Y-%m-%d %H:%M:%S')
    system_info["system_time"] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    # Network information
    system_info["network_io_sent"] = psutil.net_io_counters().bytes_sent
    system_info["network_io_received"] = psutil.net_io_counters().bytes_recv
    system_info["ip_addresses"] = {
        name: address[1][1] for name, address in psutil.net_if_addrs().items()
    }
    return (datetime.now() - start).total_seconds(), system_info


def timeout_wrapper(func, args=None, kwargs=None, timeout=3):
    """Wrap a function call with a timeout. Raises TimeoutError if the function exceeds the time limit."""
    if kwargs is None:
        kwargs = {}
    if args is None:
        args = []
    if not isinstance(timeout, int) or timeout <= 0:
        raise ValueError("timeout must be a positive integer")

    if not callable(func):
        raise TypeError("func must be callable")
    
    thread = threading.Thread(target=lambda: func(*args, **kwargs))
    thread.start()
    thread.join(timeout=timeout)
    if thread.is_alive():
        thread.join()
        raise TimeoutError(
            f"Function {func.__name__} call timed out after {timeout} seconds"
        )


def check_db_connections():
    """Check all database connections"""
    start = datetime.now()
    db_cons_states = {}
    timeout = Env.SERVER_DB_CONNECTION_CHECK_TIMEOUT  # Timeout in seconds
    def check_db_connection(results, db_name):
        """Check a specific database connection with a timeout."""
        status={}
        # Obtain a cursor using the modified options
        try:
            timeout_wrapper(lambda: connections[db_name].cursor(), timeout=timeout)
            status["state"]="CONNECTED"
        except Exception as e:
            logger.error(f"system_monitor# Database connection error for {db_name}: {str(e)}")
            status["state"]="DISCONNECTED"
        if status["state"]=="CONNECTED":
            try:
                disk_usage_data = {}
                def getDiskUsage(store_in):
                    cursor = connections[db_name].cursor()
                    cursor.execute(RAW_SQL.GET_DISK_USAGE)
                    disk_usage_data = cursor.fetchall()
                    for row in disk_usage_data:
                        store_in[row[0]]={
                            "used": row[1],
                            "available": row[2],
                            "total": row[2] + row[1],
                            "percent": row[1] * 100 / row[2],
                        }
                    cursor.close()

                timeout_wrapper(getDiskUsage, args=(disk_usage_data,), timeout=timeout)
                
                status["info"] = disk_usage_data
                status["query"]="OK"
            except Exception as e:
                logger.error(f"system_monitor# Database query error for {db_name}: {str(e)}")
                status["query"]="ERROR"
        results[db_name] = status
    def check_redis_connection(results, db_name="ibdm_redis"):
        """Check Redis connection"""
        status = {}
        try:
            redis_con = Redis(host=Env.DATABASE_IBDM_REDIS_HOST, port=Env.DATABASE_IBDM_REDIS_PORT, db=0, socket_connect_timeout=timeout)
            redis_con.ping()
            status["state"] ="CONNECTED"
            memory_info = redis_con.info()
            status["info"]= {
                "ibdm_redis": {
                    "used_memory": memory_info.get("used_memory", 0),
                    "total_memory": memory_info.get("total_system_memory",0),
                    "free_memory": memory_info.get("total_system_memory", 0)
                    - memory_info.get("used_memory", 0),
                    "percent": memory_info.get("used_memory", 0) * 100 / memory_info.get("total_system_memory", 1),
                    "total_keys": memory_info.get("db0", {}).get("keys", 0),
                    "uptime_in_seconds": memory_info.get("uptime_in_seconds", 0),
                    "connected_clients": memory_info.get("connected_clients", 0),
                }
            }
 
        except Exception as e:
           status["state"] = "DISCONNECTED"
        
        results[db_name] = status
    # Create a dictionary to store the results
    results = {}
    # Check database connections
    dbs_cons = {
        db_key: threading.Thread(target=check_db_connection, args=(results, db_key,))
        for db_key in connections.databases.keys()
    }
    dbs_cons["ibdm_redis"] = threading.Thread(target=check_redis_connection, args=(results,))
    del dbs_cons["default"]

    for db_name in dbs_cons:
        db_cons_states[db_name] = "DISCONNECTED"

    # Wait for all futures to complete
    for _, thread in dbs_cons.items():
        thread.start()

    for db_name, thread in dbs_cons.items():
        thread.join(timeout=timeout)
        db_cons_states[db_name] = results.get(db_name, "DISCONNECTED")
    return (datetime.now() - start).total_seconds(), db_cons_states


def system_monitor():
    """Run a complete monitoring cycle and save results"""
    start_time = datetime.now()
    db_elapased_time, db_connections = check_db_connections()
    system_elapsed_time, system_info = get_system_info()
    # Write to temporary file first to avoid partial writes
    temp_file = os.path.join(settings.BASE_DIR, f"status_data.{uuid.uuid4()}.json.tmp")
        
    try:
        # Collect all monitoring data
        status_data = {
            "status": "on",
            "version": settings.VERSION,
            "env": Env.ENV_MODE,
            "debug": settings.DEBUG,
            "description": "Server is running",
            "last_updated": datetime.now().isoformat(),
            "elapsed_time": "0s",
            "system_info_elapsed_time": f"{system_elapsed_time}s",
            "databases_elapsed_time": f"{db_elapased_time}s",
            "system_info": system_info,
            "databases": db_connections,
        }

        status_data["elapsed_time"] = f"{(datetime.now() - start_time).total_seconds()}s"
        with open(temp_file, 'w') as f:
            json.dump(status_data, f, indent=4, default=str)

        # Atomic rename to avoid race conditions
        os.replace(temp_file, STATUS_FILE)
        
        logger.info(f"system_monitor# Status data saved to {STATUS_FILE}")
        logger.info("system_monitor# Monitoring cycle completed successfully")
    except Exception as e:
        logger.error(f"system_monitor# Error in monitoring cycle: {str(e)}")
        logger.error(f"system_monitor# {traceback.format_exc()}")
    finally:
        # remove temp file
        if os.path.exists(temp_file):
            os.remove(temp_file)

