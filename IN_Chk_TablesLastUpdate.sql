-- Check table and indexes last update
SELECT 
	  db.name AS DatabaseName
	, OBJECT_NAME(idu.OBJECT_ID) AS TableName
	, idx.name AS IndexName
	, idx.type_desc AS IndexType
	, idu.last_user_update AS LastUpdate
	, idu.user_updates AS CountUpdates
FROM sys.dm_db_index_usage_stats idu
INNER JOIN sys.indexes idx
	ON idu.object_id = idx.object_id
INNER JOIN sys.databases db
	ON idu.database_id = db.database_id
WHERE db.database_id > 4 AND db.name NOT IN ('distribution')
ORDER BY idu.last_user_update DESC