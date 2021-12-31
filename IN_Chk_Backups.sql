-- Check backup status
SELECT 
	  msdb.dbo.backupset.database_name AS 'BackupName'
	, msdb.dbo.backupset.backup_start_date AS 'StartDate'
	, msdb.dbo.backupset.backup_finish_date AS 'StopDate'
	, msdb.dbo.backupset.expiration_date AS 'ExpirationDate'
	, CASE msdb..backupset.type 
		WHEN 'D' THEN 'Database' 
		WHEN 'L' THEN 'Log' 
	END AS 'BackupType'
	, CAST(msdb.dbo.backupset.backup_size/1024/1024 AS NUMERIC(18,2)) AS 'BackupSize (MB)'
	, msdb.dbo.backupmediafamily.logical_device_name AS 'LogicalDeviceName'
	--, msdb.dbo.backupmediafamily.physical_device_name 
	, msdb.dbo.backupset.name AS 'BackupsetName'
	--, msdb.dbo.backupset.description 
FROM msdb.dbo.backupmediafamily 
	INNER JOIN msdb.dbo.backupset ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id 
WHERE (CONVERT(datetime, msdb.dbo.backupset.backup_start_date, 102) >= GETDATE() - 7) 
ORDER BY 
	  msdb.dbo.backupset.database_name 
	, msdb.dbo.backupset.backup_finish_date 