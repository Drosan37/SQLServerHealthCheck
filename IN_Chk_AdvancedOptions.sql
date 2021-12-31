-- Check some istance parameter (usually tuned parameters)
DECLARE @command NVARCHAR(4000) ;
DECLARE @OutputTable TABLE
(
	  OptionName NVARCHAR(MAX)
    , MinimumValue FLOAT
    , MaximumValue FLOAT
    , ConfigValue FLOAT
    , RunValue FLOAT

);
BEGIN
	INSERT INTO @OutputTable
	EXEC sp_configure
		
	SELECT *
	FROM
	(
		SELECT 
			  OptionName
			, ConfigValue
		FROM @OutputTable
		WHERE UPPER(OptionName) IN
		(
			  'COST THRESHOLD FOR PARALLELISM'
			, 'MAX DEGREE OF PARALLELISM'
			, 'FILL FACTOR (%)'		
			, 'MAX WORKER THREADS'
			, 'MAX SERVER MEMORY (MB)'
		)	
	) AS SourceTable PIVOT(MAX([ConfigValue]) FOR [OptionName] IN(
		[COST THRESHOLD FOR PARALLELISM],
		[MAX DEGREE OF PARALLELISM],
		[FILL FACTOR (%)],
		[MAX WORKER THREADS],
		[MAX SERVER MEMORY (MB)])
	) AS PivotTable;		
END