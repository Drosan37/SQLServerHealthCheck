-- Check instance processes
DECLARE @command nvarchar(4000) ;
DECLARE @OutputTable TABLE
(
	  SPID INT
    , Status VARCHAR(MAX)
    , LOGIN VARCHAR(MAX)
    , HostName VARCHAR(MAX)
    , BlkBy VARCHAR(MAX)
    , DBName VARCHAR(MAX)
    , Command VARCHAR(MAX)
    , CPUTime BIGINT
    , DiskIO BIGINT
    , LastBatch VARCHAR(MAX)
    , ProgramName VARCHAR(MAX)
    , SPID_1 INT
    , REQUESTID BIGINT
);
BEGIN


INSERT INTO @OutputTable
EXEC sp_who2;

SELECT 
	TOP 50 *
	, CAST ( 
		CASE 
        WHEN DiskIO >=  100000 THEN 'TRUE'
		WHEN BlkBy <> '  .' THEN 'TRUE'
        ELSE 'FALSE'
      END AS VARCHAR) AS FlagUnderline 
FROM @OutputTable
ORDER BY 
	  DiskIO DESC
	, CPUTime DESC;
END;
