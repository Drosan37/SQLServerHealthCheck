-- Query for check sessions with query text
SELECT 
	  rq.session_id
	, rq.start_time
	, rq.status
	, rq.command
	, rq.database_id
	, rq.blocking_session_id
	, rq.last_wait_type
	, hdl.text
	--, rq.*
FROM sys.dm_exec_requests rq  
CROSS APPLY sys.dm_exec_sql_text(sql_handle) hdl
