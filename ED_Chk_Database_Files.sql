-- Check datafile and transaction log space for every databases on instance
DECLARE @command NVARCHAR(4000) ;
DECLARE @OutputTable TABLE
(
	  DatabaseName VARCHAR(200) 
	, FileName VARCHAR(200)
	, FileTypeDesc VARCHAR(200)
	, FilePath VARCHAR(255)
	, AllocatedSpace DECIMAL(15,0)
	, SpaceUsed DECIMAL(15,0)
	, AvailableSpace DECIMAL(15,0)
	, MaxSpace	 DECIMAL(15,0)
	, GrowthMB DECIMAL(15,0)
	, GrowthTypeOrValue VARCHAR(200)
	, SpaceUsedPercent INT	
);
BEGIN
SET @command = 'USE [?] ;' +
'SELECT
	  DbName
	, FileName
	, FileTypeDesc
	, physical_name AS FilePath
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
FROM
(
	SELECT 
		  DB_NAME() AS DbName
		, name AS FileName
		, type_desc AS FileTypeDesc
		, CONVERT (DECIMAL(15,0),ROUND(size/128.000,0)) AS AllocatedSpace
		, CONVERT(DECIMAL(15,0),ROUND(FILEPROPERTY(name,''SpaceUsed'')/128.000,0)) AS SpaceUsed
		, CONVERT (DECIMAL(15,0),ROUND((size-FILEPROPERTY(name,''SpaceUsed''))/128.000,0)) AS AvailableSpace
		, CONVERT (DECIMAL(15,0),ROUND((
			CASE 
				WHEN max_size = -1 THEN 0
				WHEN max_size = 268435456  AND type = 1 THEN 0
				ELSE max_size
			END)/128.000,0)) AS MaxSpace
		, is_percent_growth
		, ROUND(CONVERT(DECIMAL(15,0), (growth/128.000)),0) AS Growth
		, CASE 
			WHEN is_percent_growth = 1 THEN CONCAT(growth,''%'')
			WHEN growth = 0 THEN ''NoGrowth''
			ELSE ''AbsoluteGrowth''
		END AS GrowthTypeOrValue 
		, type AS FileType
		, physical_name
	FROM sys.database_files (NOLOCK)
	WHERE type IN (0,1)
) tbl
ORDER BY FileType;'

INSERT INTO @OutputTable
EXEC sp_MSforeachdb @command;

SELECT 
	*
	, CAST ( 
		CASE 
        WHEN SpaceUsedPercent >=  90 AND MaxSpace > 0 THEN 'RED'
		WHEN SpaceUsedPercent >=  90 AND MaxSpace = 0 THEN 'YELLOW'
        ELSE 'GREEN'
      END AS VARCHAR) AS FlagUnderline
FROM @OutputTable
ORDER BY FlagUnderline DESC, SpaceUsedPercent DESC;
END;

