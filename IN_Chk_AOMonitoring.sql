-- Always On status with estimated data loss rounded to 2 decimal places
SELECT 
    ag.name AS [Availability Group],
    ar.replica_server_name AS [Replica Server],
    ar.availability_mode_desc AS [Availability Mode],
    ar.failover_mode_desc AS [Failover Mode],
    ars.role_desc AS [Current Role],
    ars.connected_state_desc AS [Connected State],
    ars.synchronization_health_desc AS [Synchronization Health],
    d.name AS [Database Name],
    drs.synchronization_state_desc AS [Sync State],
    drs.redo_queue_size AS [Redo Queue Size (KB)],
    drs.redo_rate AS [Redo Rate (KB/sec)],
    drs.log_send_queue_size AS [Log Send Queue Size (KB)],
    drs.log_send_rate AS [Log Send Rate (KB/sec)],
    CASE 
        WHEN drs.log_send_rate > 0 
        THEN ROUND(CAST(drs.log_send_queue_size AS FLOAT) / drs.log_send_rate, 2)
        ELSE NULL
    END AS [Estimated Data Loss (sec)]
FROM 
    sys.availability_groups ag
JOIN 
    sys.availability_replicas ar ON ag.group_id = ar.group_id
JOIN 
    sys.dm_hadr_availability_replica_states ars ON ar.replica_id = ars.replica_id
JOIN 
    sys.dm_hadr_database_replica_states drs ON ars.replica_id = drs.replica_id
JOIN 
    sys.databases d ON drs.database_id = d.database_id
WHERE 
    drs.is_local = 1
ORDER BY 
    ag.name, ar.replica_server_name, d.name;
