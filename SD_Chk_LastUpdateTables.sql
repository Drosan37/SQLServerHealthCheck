-- Script for check last update o scan table
SELECT
	*
FROM
(
SELECT 
	DB_NAME(database_id) AS DatabaseName
	, tbl.name AS TableName
	, last_user_update
	, last_user_scan
	, last_user_seek
	, last_user_lookup
	, tbl.create_date
	, ROW_NUMBER() OVER (PARTITION BY tbl.name ORDER BY last_user_scan DESC, last_user_update DESC) AS RowNum
FROM sys.dm_db_index_usage_stats ius
INNER JOIN sys.tables tbl ON ius.object_id = tbl.object_id AND ius.database_id = DB_ID()
WHERE database_id > 5 AND DB_NAME(ius.database_id) NOT IN ('distribution')
) res
WHERE res.RowNum = 1
ORDER BY res.DatabaseName, res.TableName, res.create_date