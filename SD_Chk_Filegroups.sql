-- Script for check filegroups on single database
SELECT
	  b.groupname AS 'Filegroup'
	, a.AllocatedSpace
	, a.SpaceUsed	
	, a.AvailableSpace
	, a.MaxSpace 
	, CONVERT(INTEGER,ROUND((a.SpaceUsed/a.AllocatedSpace*100),0)) AS SpaceUsedPercent
FROM 
(
	SELECT
		  sf.groupid
		, SUM(sf.AllocatedSpace) AS AllocatedSpace
		, SUM(sf.SpaceUsed) AS SpaceUsed		
		, SUM(sf.AvailableSpace) AS AvailableSpace
		, SUM(sf.MaxSpace) AS MaxSpace 
	FROM
	(
		SELECT 
			  groupid
			, name
			, CONVERT(DECIMAL(15,2),ROUND(FILEPROPERTY(name,'SpaceUsed')/128.000,2)) AS SpaceUsed
			, CONVERT (Decimal(15,2),ROUND(size/128.000,2)) AS AllocatedSpace
			, CONVERT (Decimal(15,2),ROUND((size-FILEPROPERTY(name,'SpaceUsed'))/128.000,2)) AS AvailableSpace
			, CONVERT (Decimal(15,2),ROUND((
				CASE maxsize
					WHEN -1 THEN 0
					ELSE maxsize
				END)/128.000,2)) AS MaxSpace 
		FROM sysfiles (NOLOCK)
		WHERE groupid > 0
	) sf
	GROUP BY sf.groupid
) a
JOIN sysfilegroups b (NOLOCK) ON a.groupid = b.groupid
ORDER BY b.groupname