-- Check Backup-Restore processing status
SELECT 
	  session_id as SPID
	, command AS CommandType
	, a.text AS Query
	, start_time AS StartTime
	, percent_complete AS PercentComplete
	, DATEADD(second,estimated_completion_time/1000, GETDATE()) AS EstimatedCompletionTime
FROM sys.dm_exec_requests r CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) a
WHERE r.command in ('BACKUP DATABASE','RESTORE DATABASE','DbccFilesCompact')
