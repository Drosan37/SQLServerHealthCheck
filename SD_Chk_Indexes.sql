-- Query for check index status
SELECT 
	  dbschemas.[name] AS SchemaName
	, dbtables.[name] AS TableName
	, dbindexes.[name] AS IndexName
	, ROUND(indexstats.avg_fragmentation_in_percent,0) AS FragmentationPerc
	, indexstats.page_count AS [PageCount]
	, dbindexes.fill_factor AS [FillFactor]
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS indexstats
INNER JOIN sys.tables dbtables on dbtables.[object_id] = indexstats.[object_id]
INNER JOIN sys.schemas dbschemas on dbtables.[schema_id] = dbschemas.[schema_id]
INNER JOIN sys.indexes AS dbindexes ON dbindexes.[object_id] = indexstats.[object_id]
AND indexstats.index_id = dbindexes.index_id
WHERE indexstats.database_id = DB_ID()
ORDER BY indexstats.avg_fragmentation_in_percent DESC