-- Script for check Job status (Job Activity Monitor like) only for job running (no stopped)
DECLARE @job_name SYSNAME = '<JobName, VARCHAR(255), none>';
DECLARE @job_id UNIQUEIDENTIFIER = (SELECT TOP 1 job_id FROM msdb..sysjobs WHERE name = @job_name);
DECLARE @job_owner SYSNAME = (SELECT SUSER_SNAME());
DECLARE @xp_results TABLE (
    job_id UNIQUEIDENTIFIER NOT NULL,
    last_run_date INT NOT NULL,
    last_run_time INT NOT NULL,
    next_run_date INT NOT NULL,
    next_run_time INT NOT NULL,
    next_run_schedule_id INT NOT NULL,
    requested_to_run INT NOT NULL, -- BOOL
    request_source INT NOT NULL,
    request_source_id SYSNAME COLLATE database_default NULL,
    running INT NOT NULL, -- BOOL
    current_step INT NOT NULL,
    current_retry_attempt INT NOT NULL,
    job_state INT NOT NULL);

INSERT INTO @xp_results
    EXECUTE master.dbo.xp_sqlagent_enum_jobs 1, @job_owner, @job_id

SELECT sj.name,
	CASE xpr.job_state WHEN 1 THEN 'Executing: ' + CAST(sjs.step_id AS NVARCHAR(2)) + ' (' + sjs.step_name + ')'
		WHEN 2 THEN 'Waiting for thread'
		WHEN 3 THEN 'Between retries'
		WHEN 4 THEN 'Idle'
		WHEN 5 THEN 'Suspended'
		WHEN 7 THEN 'Performing completion actions'
    END AS [status]
FROM @xp_results xpr
INNER JOIN msdb..sysjobs sj 
	ON xpr.job_id = sj.job_id
LEFT OUTER JOIN msdb.dbo.sysjobsteps sjs 
	ON ((xpr.job_id = sjs.job_id) AND (xpr.current_step = sjs.step_id))
