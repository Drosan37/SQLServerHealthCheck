-- Check top 10 Query
SELECT TOP 10 
	SUBSTRING(qt.TEXT,(qs.statement_start_offset/2)+1,(
	(CASE qs.statement_end_offset
		WHEN -1 THEN DATALENGTH(qt.TEXT)
		ELSE qs.statement_end_offset
	END - qs.statement_start_offset)/2)+1) AS QueryText
	, DB_NAME(qt.dbid) AS DatabaseName
	, qs.execution_count AS ExecutionCount
	, qs.total_logical_reads AS TotLogicalReads
	, qs.last_logical_reads AS LastLogicalReads
	, qs.total_logical_writes AS TotLogicalWrites
	, qs.last_logical_writes AS LastLogicalWrite
	, qs.total_worker_time AS TotWorkerTime
	, qs.last_worker_time AS LastWorkerTime
	, (qs.total_elapsed_time/1000000) AS TotElapsedTime_Sec
	, (qs.last_elapsed_time/1000000) AS LastElapsedTime_Sec
	, qs.last_execution_time AS LastExecutionTime
	, qp.query_plan AS QueryPlanXmlDownload
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
ORDER BY qs.total_logical_reads DESC -- logical reads
-- ORDER BY qs.total_logical_writes DESC -- logical writes
-- ORDER BY qs.total_worker_time DESC -- CPU time