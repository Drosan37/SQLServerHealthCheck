--DROP TABLE #SpaceUsed

DECLARE @SpaceUsed TABLE 
(
	  TableName SYSNAME
	, NumRows BIGINT
	, ReservedSpace VARCHAR(50)
	, DataSpace VARCHAR(50)
	, IndexSize VARCHAR(50)
	, UnusedSpace VARCHAR(50)
) 

DECLARE @strCmd VARCHAR(500) =  'exec sp_spaceused ''?'''

INSERT INTO @SpaceUsed 
EXEC sp_msforeachtable @command1=@strCmd

SELECT 
	  TableName
	, NumRows	
    , REPLACE(ReservedSpace,' KB','') AS "ReservedSpace(KB)"
	, REPLACE(DataSpace,' KB','') AS "DataSpace(KB)"
	, REPLACE(IndexSize,' KB','') AS "IndexSize(KB)"
	, REPLACE(UnusedSpace,' KB','') AS "UnusedSpace(KB)"
FROM @SpaceUsed 
ORDER BY TableName