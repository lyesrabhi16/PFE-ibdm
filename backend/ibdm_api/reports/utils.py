from api_v1.utils import ensurePathExists
import os
from logs.logging import logger as logging
from django.conf import settings


def get_paths_of_reports_from_directory(directory_path):
    """
    Function to read reports from a directory.
    """
    reports = []
    try:
        #print("directory_path", directory_path)
        for filename in os.listdir(directory_path):
            reports.append(os.path.join(directory_path, filename))
    except Exception as e:
        logging.error(f"Error reading reports from directory {directory_path}: {e}")
        print(f"Error reading reports from directory {directory_path}: {e}")
    return reports

def get_existing_reports_from_disk(reports_dirname: str) -> list|None:
    """
    Function to get existing reports from disk.
    This is a placeholder function. Replace it with your actual implementation.
    """
    # Example implementation
    try:
        # Assuming reports are stored in a specific directory
        reports_directory = os.path.join(settings.BASE_DIR, "data", "rapports", "", reports_dirname)
        ensurePathExists(reports_directory)
        reports_paths = get_paths_of_reports_from_directory(reports_directory)
        return reports_paths
    except Exception as e:
        logging.error(f"Error reading reports from disk: {e}")