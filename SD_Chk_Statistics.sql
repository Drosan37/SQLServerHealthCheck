-- Check stats for tables and indexes
SELECT DISTINCT
		  OBJECT_NAME(s.[object_id]) AS TableName
		, c.name AS ColumnName
		, s.name AS StatName
		, STATS_DATE(s.[object_id], s.stats_id) AS LastUpdated
		, DATEDIFF(d,STATS_DATE(s.[object_id], s.stats_id),GETDATE()) DaysOld
		, sch.name as SchemaName 	
	FROM sys.stats s
	JOIN sys.stats_columns sc ON sc.[object_id] = s.[object_id] AND sc.stats_id = s.stats_id
	JOIN sys.columns c ON c.[object_id] = sc.[object_id] AND c.column_id = sc.column_id
	JOIN sys.partitions par ON par.[object_id] = s.[object_id]
	JOIN sys.objects obj ON par.[object_id] = obj.[object_id]
	JOIN sys.schemas sch ON obj.schema_id = sch.schema_id
	CROSS APPLY sys.dm_db_stats_properties(sc.[object_id], s.stats_id) AS dsp
	WHERE OBJECTPROPERTY(s.OBJECT_ID,'IsUserTable') = 1
	AND (s.auto_created = 1 OR s.user_created = 1)
ORDER BY DaysOld DESC;