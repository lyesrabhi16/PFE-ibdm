from datetime import datetime, timedelta
import os
from drf_spectacular.utils import extend_schema
from rest_framework import viewsets

from logs.logging import logger as logging
from django.conf import settings
import json
import time

from django.db.models import Q
from concurrent.futures import ThreadPoolExecutor



def getServerStatusFromFile():
    status_file = settings.STATUS_FILE_PATH
    
    if os.path.exists(status_file):
            file_age = time.time() - os.path.getmtime(status_file)
            
                # Read status data from file
            with open(status_file, 'r') as f:
                status_data = json.load(f)
            
            # Add file age information
            status_data['status_file_age_seconds'] = file_age
            
            # If file is too old, add a warning
            if file_age > 300:  # 5 minutes
                status_data['warning'] = "Status data is more than 5 minutes old"
            return status_data
    return None


def get_values_within(model, startDate, endDate):

    print_log("VALUES", f'{model} ${startDate} to ${endDate}')
    

    # Query for exactly midnight (00:00:xx)
    return model.objects.filter(
        date__gte=startDate,
        date__lt=endDate
    )

def get_value_at(model, date):

    print_log("VALUE", f'{model} ${date}')
    

    next_second = date + timedelta(seconds=1)
    print_log("VALUE", f'{date} ${next_second}')
    # Query for exactly midnight (00:00:xx)
    return model.objects.filter(
        date__gte=date,
        date__lt=next_second
    ).first()

def get_midnight_value(model):
    now = datetime.now()
    # Get today at midnight
    today_midnight = now.replace(hour=0, minute=0, second=0)
    # Get today at 00:01
    next_minute = today_midnight.replace(minute=1)

    # Query for exactly midnight (00:00:xx)
    return model.objects.filter(
        date__gte=today_midnight,
        date__lt=next_minute
    ).first()

def print_log(name="LOG", *args):
    logging.info("="*5+">"+name+"<"+"="*5)
    logging.info(f"{datetime.now()} {args}")
    logging.info("="*5+">"+name+"<"+"="*5)

def get_or_none(class_model, get_function, args, **kwargs):
    try:
        return get_function(*args, **kwargs)
    except class_model.DoesNotExist:
        return None

def with_operation_ids(
        on_list: str|None = None,
        on_retrieve: str|None = None,
        on_create: str|None = None,
        on_update: str|None = None,
        on_partial_update: str|None = None,
        on_destroy: str|None = None,
):
    def decorator(cls):
        if issubclass(cls, viewsets.ReadOnlyModelViewSet):
            class WrappedReadOnlyModelViewClass(cls):
                # Optionally, override methods if needed
                
                def __init__(self, *args, **kwargs):
                    super().__init__(*args, **kwargs)

                @extend_schema(
                    operation_id=on_list
                )
                def list(self, request, *args, **kwargs):
                    return super().list(request, *args, **kwargs)
                @extend_schema(
                    operation_id=on_retrieve
                )
                def retrieve(self, request, *args, **kwargs):
                    return super().retrieve(request, *args, **kwargs)
            
            WrappedReadOnlyModelViewClass.__name__ = cls.__name__
            WrappedReadOnlyModelViewClass.__doc__ = cls.__doc__
            WrappedReadOnlyModelViewClass.__module__ = cls.__module__
            return WrappedReadOnlyModelViewClass
        elif  issubclass(cls, viewsets.ModelViewSet):
            class WrappedModelViewSetClass(cls):
                # Optionally, override methods if needed
                
                def __init__(self, *args, **kwargs):
                    super().__init__(*args, **kwargs)

                @extend_schema(
                    operation_id=on_list
                )
                def list(self, request, *args, **kwargs):
                    return super().list(request, *args, **kwargs)
                @extend_schema(
                    operation_id=on_retrieve
                )
                def retrieve(self, request, *args, **kwargs):
                    return super().retrieve(request, *args, **kwargs)
                @extend_schema(
                    operation_id=on_create
                )
                def create(self, request, *args, **kwargs):
                    return super().create(request, *args, **kwargs)
                @extend_schema(
                    operation_id=on_update
                )
                def update(self, request, *args, **kwargs):
                    return super().update(request, *args, **kwargs)
                @extend_schema(
                    operation_id=on_partial_update
                )
                def partial_update(self, request, *args, **kwargs):
                    return super().partial_update(request, *args, **kwargs)
                @extend_schema(
                    operation_id=on_destroy
                )
                def destroy(self, request, *args, **kwargs):
                    return super().destroy(request, *args, **kwargs)
                
            
            WrappedModelViewSetClass.__name__ = cls.__name__
            WrappedModelViewSetClass.__doc__ = cls.__doc__
            WrappedModelViewSetClass.__module__ = cls.__module__
            return WrappedModelViewSetClass
        else:
            raise ValueError("This decorator only works with classes that inherit from viewsets.ModelViewSet or viewsets.ReadOnlyModelViewSet")
    return decorator



def filter_by_fetch_type(model, start_date, end_date,fetch_type):
        def normalize_date(date, fetch_type):
            if fetch_type == "seconds":
                return date.replace(microsecond=0)
            elif fetch_type == "minutes":
                return date.replace(second=0, microsecond=0)
            elif fetch_type == "hours":
                return date.replace(minute=0, second=0, microsecond=0)
            elif fetch_type == "days":
                return date.replace(hour=0, minute=0, second=0, microsecond=0)
            elif fetch_type == "weeks":
                day_of_week = date.weekday()
                return (date - timedelta(days=day_of_week)).replace(hour=0, minute=0, second=0, microsecond=0)
            elif fetch_type == "months":
                return date.replace(day=1, hour=0, minute=0, second=0, microsecond=0)
            elif fetch_type == "years":
                return date.replace(month=1, day=1, hour=0, minute=0, second=0, microsecond=0)
            return date
        def appendToDates(date, dates):
                if dates == []:
                    dates.append([date])
                else:
                    if len(dates[-1]) < 500:
                        dates[-1].append(date)
                    else:
                        dates.append([date])

        def get_all_possible_dates_from_chunks(chunked_dates, fetch_type, customQ=None):
            threads = []

            all_possible_dates = set()
            current_chunk = 0
            all_chunks = len(chunked_dates)
            
            with ThreadPoolExecutor() as executor:
                def process_chunk(chunk, chunk_index):
                    query = Q()
                    print("chunk", len(chunk), chunk_index, "/", all_chunks)
                    for date in chunk:
                        if customQ is not None:
                            query |= customQ(date, fetch_type)
                        else:
                            query |= Q(date__range=(date.replace(minute=59,second=0), date.replace(minute=59,second=59)))
                    _dates = model.objects.filter(query).distinct().order_by("-date").values_list("date", flat=True)

                    date_dict = {}
                    for date in _dates:
                        normalized_date = normalize_date(date, fetch_type)
                        if normalized_date not in date_dict:
                            date_dict[normalized_date] = date
                    
                    print("chunk", chunk_index, "size: ", _dates.count(),"normalized possible_dates size: ", len(date_dict))
                    return date_dict.values()

                for chunk in chunked_dates:
                    current_chunk += 1
                    threads.append(executor.submit(process_chunk, chunk, current_chunk))
                for future in threads:
                    all_possible_dates.update(future.result())
            print("all_possible_dates size: ", len(all_possible_dates))
            print("all_possible_dates gathered, took: ", (datetime.now() - start).total_seconds())

            return all_possible_dates

        start = datetime.now()
        
        # Mapping fetch types to their threshold values
        thresholds = {
            "all": 0.001,
            "seconds": 1,
            "minutes": 60,
            "hours": 3600,
            "days": 86400,
            "weeks": 604800,
            "months": 2592000,
            "years": 31536000
        }
        print("fetch_type", fetch_type)
        threshold = thresholds.get(fetch_type)
        if threshold is None:
            print("Invalid fetch_type provided.")
            return model.objects.none()
        
        if fetch_type == "all":
            return model.objects.filter(
                date__range=(start_date, end_date)
            ).order_by("-date")


        dates = []
        d = start_date
        while d <= end_date:
            appendToDates(d, dates)
            d += timedelta(seconds=threshold)
        
        values = []
        seen_dates = set()
        with ThreadPoolExecutor() as executor:
            def process_chunk(chunk, dates, values, seen_dates, fetch_type):
                    print(f"chunk {len(chunk)} {dates.index(chunk) + 1}/{len(dates)} range: {chunk[0]} - {chunk[-1]}")
                    q = Q()
                    for date in chunk:
                        match fetch_type:
                            case "seconds":
                                start_date = date.replace(microsecond=0)
                                end_date = date.replace(microsecond=999999)
                            case "minutes":
                                start_date = date.replace(second=55, microsecond=0)
                                end_date = date.replace(second=59, microsecond=999999)
                            case "hours":
                                start_date = date.replace(minute=59, second=55, microsecond=0)
                                end_date = date.replace(minute=59, second=59, microsecond=999999)
                            case "days":
                                start_date = date.replace(hour=23, minute=55, second=0, microsecond=0)
                                end_date = date.replace(hour=23, minute=59, second=59, microsecond=999999)
                            case "weeks":
                                end_of_week_date = date + timedelta(days=(6 - date.weekday()))
                                start_date = end_of_week_date.replace(hour=23, minute=59, second=0, microsecond=0)
                                end_date = end_of_week_date.replace(hour=23, minute=59, second=59, microsecond=999999)
                            case "months":
                                if date.month in [1, 3, 5, 7, 8, 10, 12]:
                                    start_date = date.replace(day=31, hour=23, minute=55, second=0, microsecond=0)
                                    end_date = date.replace(day=31, hour=23, minute=59, second=59, microsecond=999999)
                                elif date.month in [4, 6, 9, 11]:
                                    start_date = date.replace(day=30, hour=23, minute=55, second=0, microsecond=0)
                                    end_date = date.replace(day=30, hour=23, minute=59, second=59, microsecond=999999)
                                elif date.month == 2:
                                    if (date.year % 4 == 0 and date.year % 100 != 0) or (date.year % 400 == 0):
                                        start_date = date.replace(day=29, hour=23, minute=55, second=0, microsecond=0)
                                        end_date = date.replace(day=29, hour=23, minute=59, second=59, microsecond=999999)
                                    else:
                                        start_date = date.replace(day=28, hour=23, minute=55, second=0, microsecond=0)
                                        end_date = date.replace(day=28, hour=23, minute=59, second=59, microsecond=999999)
                            case "years":
                                start_date = date.replace(month=12, day=31, hour=23, minute=59, second=0, microsecond=0)
                                end_date = date.replace(month=12, day=31, hour=23, minute=59, second=59, microsecond=999999)

                        q |= Q(date__range=(start_date, end_date))
                    queryset = model.objects.filter(q).distinct().order_by("-date")
                    print("queryset", queryset.count())
                    for record in queryset:
                        normalized_date = normalize_date(record.date, fetch_type)
                        if normalized_date not in seen_dates:
                            seen_dates.add(normalized_date)
                            values.append(record)
                    print("done")
            
            futures = []
            for chunk in dates:
                futures.append(executor.submit(process_chunk, chunk,dates, values, seen_dates, fetch_type))

            for future in futures:
                future.result()

        print("values", len(values))
        # Get final queryset with unique normalized dates
        #final_queryset = Sucre.objects.filter(date__in=values).order_by("-date")
        
        print(f"Results: {len(values)}")
        print(f"Took: {(datetime.now() - start).total_seconds()}")
        
        return sorted(values, key=lambda x: x.date, reverse=True)
    
