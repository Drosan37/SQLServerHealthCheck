-- Check Instance properties
SELECT
	  ProductVersion
	, CASE SUBSTRING(ProductVersion,1,2)
		WHEN '15' THEN 'SQL Server 2019'
		WHEN '14' THEN 'SQL Server 2017'	
		WHEN '13' THEN 'SQL Server 2016'		
		WHEN '12' THEN 'SQL Server 2014'
		WHEN '11' THEN 'SQL Server 2012'
		WHEN '10.5' THEN 'SQL Server 2008 R2'
		WHEN '10' THEN 'SQL Server 2008'
		WHEN '9.' THEN 'SQL Server 2005'
	END AS VersionName
	, ProductLevel
	, Edition
	, CASE IsClustered
		WHEN 0 THEN 'No Cluster'
		WHEN 1 THEN 'Cluster'
	END AS ClusterMode
	, CASE IsHadrEnabled
		WHEN 0 THEN 'No Always On Activated'
		WHEN 1 THEN 'Always On Activated'
		ELSE 'Not Available'
	END AS AlwaysOnOption
	, SqlCharSetName
FROM
(
SELECT
	CONVERT(VARCHAR(200),SERVERPROPERTY('ProductVersion')) AS ProductVersion
	, SERVERPROPERTY('ProductLevel') AS ProductLevel
	, SERVERPROPERTY('Edition') AS Edition
	, SERVERPROPERTY('IsClustered') AS IsClustered
	, SERVERPROPERTY('IsHadrEnabled') AS IsHadrEnabled
	, SERVERPROPERTY('SqlCharSetName') AS SqlCharSetName
) AS InstancesInfo
