-- Script for check statistics for all database
DECLARE @inputDateRange NVARCHAR(4) = -10
DECLARE @command NVARCHAR(4000) ;
DECLARE @OutputTable TABLE
(
	  DatabaseName NVARCHAR(200)
	, TableName NVARCHAR(200)
	, SchemaName NVARCHAR(200) 	
	, LastUpdated DATETIME 
	, DaysOld BIGINT 
);
BEGIN
	SET @command = 'USE [?] ;' +
	'IF ''?'' NOT IN(''master'', ''model'', ''msdb'', ''tempdb'',''distribution'')
	BEGIN
		SELECT
			  DB_NAME() AS DatabaseName 
			, TableName
			, SchemaName
			, LastUpdated
			, DaysOld
		FROM
		(
			SELECT 
			*
			, row_number() over (partition by TableName ORDER BY LastUpdated DESC) As RowNum
			FROM
			(
				SELECT DISTINCT
				OBJECT_NAME(s.[object_id]) AS TableName,
				c.name AS ColumnName,
				s.name AS StatName,
				STATS_DATE(s.[object_id], s.stats_id) AS LastUpdated,
				DATEDIFF(d,STATS_DATE(s.[object_id], s.stats_id),getdate()) DaysOld,
				sch.name as SchemaName 	
				FROM sys.stats s
				JOIN sys.stats_columns sc
				ON sc.[object_id] = s.[object_id] AND sc.stats_id = s.stats_id
				JOIN sys.columns c ON c.[object_id] = sc.[object_id] AND c.column_id = sc.column_id
				JOIN sys.partitions par ON par.[object_id] = s.[object_id]
				JOIN sys.objects obj ON par.[object_id] = obj.[object_id]
				JOIN sys.schemas sch ON obj.schema_id = sch.schema_id
				CROSS APPLY sys.dm_db_stats_properties(sc.[object_id], s.stats_id) AS dsp
				WHERE OBJECTPROPERTY(s.OBJECT_ID,''IsUserTable'') = 1
				AND (s.auto_created = 1 OR s.user_created = 1)
			) tbl
		) res
		WHERE RowNum = 1
		AND LastUpdated < DATEADD(d,' + @inputDateRange + ',GETDATE())
	END;
	'

	INSERT INTO @OutputTable
	EXEC sp_MSforeachdb @command;

	SELECT 
		*
		, 'USE ' + QUOTENAME(DatabaseName) + '; UPDATE STATISTICS ' + QUOTENAME(SchemaName) + '.' + QUOTENAME(TableName) + ' WITH FULLSCAN;' AS CMD
	FROM @OutputTable
	ORDER BY DaysOld DESC;
END;