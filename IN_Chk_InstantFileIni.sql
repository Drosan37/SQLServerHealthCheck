-- Query for check if Instant File Initialization is enabled
SELECT  
	  servicename as ServiceDisplayName
	, service_account as ServiceAccount
    , instant_file_initialization_enabled as InstantFileInitializationEnabled
FROM  sys.dm_server_services
WHERE servicename LIKE 'SQL Server (%'