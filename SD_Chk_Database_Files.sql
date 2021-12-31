-- Check for used space on datafile and transaction log
SELECT
	  DbName
	, FileName
	, FileTypeDesc
	, AllocatedSpace
	, SpaceUsed
	, AvailableSpace
	, MaxSpace	
	,  CASE is_percent_growth
		WHEN 1 THEN CONVERT (DECIMAL(15,0),ROUND((AllocatedSpace*growth)/100,0))
		ELSE growth
	END AS GrowthMB
	, GrowthTypeOrValue
	, CONVERT(INTEGER,ROUND((SpaceUsed/AllocatedSpace*100),0)) AS SpaceUsedPercent
	, physical_name AS FilePath
FROM
(
	SELECT 
		  DB_NAME() AS DbName
		, name AS FileName
		, type_desc AS FileTypeDesc
		, CONVERT (DECIMAL(15,0),ROUND(size/128.000,0)) AS AllocatedSpace
		, CONVERT(DECIMAL(15,0),ROUND(FILEPROPERTY(name,'SpaceUsed')/128.000,0)) AS SpaceUsed
		, CONVERT (DECIMAL(15,0),ROUND((size-FILEPROPERTY(name,'SpaceUsed'))/128.000,0)) AS AvailableSpace
		, CONVERT (DECIMAL(15,0),ROUND((
			CASE 
				WHEN max_size = -1 THEN 0
				WHEN max_size = 268435456  AND type = 1 THEN 0
				ELSE max_size
			END)/128.000,0)) AS MaxSpace
		, is_percent_growth
		, ROUND(CONVERT(DECIMAL(15,0), (growth/128.000)),0) AS Growth
		, CASE 
			WHEN is_percent_growth = 1 THEN CONCAT(growth,'%')
			WHEN growth = 0 THEN 'NoGrowth'
			ELSE 'AbsoluteGrowth'
		END AS GrowthTypeOrValue 
		, type AS FileType
		, physical_name
	FROM sys.database_files (NOLOCK)
	WHERE type IN (0,1)
) tbl
ORDER BY FileType;