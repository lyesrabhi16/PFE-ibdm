
class RAW_SQL:
    GET_DISK_USAGE = """
                        SELECT  name as file_name, (size * 8 /1024) as total_size_mb, (size - CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT) * 8 /1024) AS free_space_mb,
                                (CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT) * 8 /1024) AS used_space_mb
                                from sys.database_files
                     """