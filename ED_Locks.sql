DECLARE @command nvarchar(4000) ;
DECLARE @OutputTable TABLE
(
	  login_name NVARCHAR(MAX)
	, program_name NVARCHAR(MAX)	
	, client_version INT
	, cpu_time BIGINT
	--, host_name NVARCHAR(MAX)
	, lock_timeout INT
	, logical_reads BIGINT
	, status NVARCHAR(MAX)
	, deadlock_priority BIGINT
	, memory_usage BIGINT
	, total_elapsed_time	BIGINT
	, wait_type NVARCHAR(MAX)
	--, resource_description NVARCHAR(MAX)	
)
SET @command = 'USE ? ;' +
' SELECT ' + 
' 	  es.login_name' + 
' 	, es.program_name	' + 
' 	, es.client_version' + 
' 	, es.cpu_time' + 
--' 	, es.host_name' + 
' 	, es.lock_timeout' + 
' 	, es.logical_reads' + 
' 	, es.status' + 
' 	, es.deadlock_priority' + 
' 	, es.memory_usage' + 
' 	, es.total_elapsed_time	' + 
' 	, wt.wait_type' + 
--' 	, wt.resource_description' + 
' FROM sys.dm_exec_sessions es' + 
' JOIN sys.dm_os_waiting_tasks wt ON wt.session_id = es.session_id' + 
' WHERE wt.blocking_session_id IS NOT NULL;';

INSERT INTO @OutputTable
EXEC sp_MSforeachdb @command;

SELECT * FROM @OutputTable --WHERE status <> 'GRANT'




DECLARE @command nvarchar(4000) ;
DECLARE @OutputTable TABLE
(
	  spid BIGINT
	, dbid BIGINT
	, objid BIGINT
	, indid INT
	, type NVARCHAR(10)
	, resource NVARCHAR(max)
	, mode NCHAR(10)
	, status NVARCHAR(10)
)
SET @command = 'USE ? ;' +
'EXEC sp_lock;';

INSERT INTO @OutputTable
EXEC sp_MSforeachdb @command;

SELECT * FROM @OutputTable WHERE status <> 'GRANT'

