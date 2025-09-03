-- Check CPU status
DECLARE @max INT
SELECT @max = max_workers_count FROM sys.dm_os_sys_info

SELECT
	  @MAX AS 'TotalThreads'
	, SUM(active_Workers_count) AS 'CurrentThreads'
	, @MAX - SUM(active_Workers_count) AS 'AvailableThreads'
	, SUM(runnable_tasks_count) AS 'WorkersWaitingForCpu'
	, SUM(work_queue_count) AS 'RequestWaitingForThreads' 
	, SUM(current_workers_count) AS 'AssociatedWorkers'
FROM sys.dm_os_Schedulers 
WHERE status='VISIBLE ONLINE'
