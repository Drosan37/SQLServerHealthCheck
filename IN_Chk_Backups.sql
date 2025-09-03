-- Check last backup for DB
DECLARE 
	  @RetentionDays INT = 7
	, @RowNumber INT = 1
BEGIN
	SELECT
		  BackupName
		, StartDate
		, StopDate
		, BackupType
		, [BackupSize (MB)]
		, BackupsetName
	FROM 
	(
		SELECT DISTINCT
			  msdb.dbo.backupset.database_name AS 'BackupName'
			, msdb.dbo.backupset.backup_start_date AS 'StartDate'
			, msdb.dbo.backupset.backup_finish_date AS 'StopDate'
			, msdb.dbo.backupset.expiration_date AS 'ExpirationDate'
			, CASE msdb.dbo.backupset.type 
				WHEN 'D' THEN 'Database' 
				WHEN 'L' THEN 'Log' 
			END AS 'BackupType'
			, CAST(msdb.dbo.backupset.backup_size/1024/1024 AS NUMERIC(18,2)) AS 'BackupSize (MB)'
			, msdb.dbo.backupmediafamily.logical_device_name AS 'LogicalDeviceName'		
			, msdb.dbo.backupset.name AS 'BackupsetName'		
			, ROW_NUMBER() OVER (PARTITION BY msdb.dbo.backupset.database_name, msdb..backupset.type  ORDER BY msdb.dbo.backupset.backup_finish_date DESC) AS RowNum
		FROM msdb.dbo.backupmediafamily 
			INNER JOIN msdb.dbo.backupset ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id 	
	) tbl
	WHERE 1=1
	AND (StartDate >= GETDATE() - @RetentionDays)
	AND RowNum <= @RowNumber
	ORDER BY 
		  BackupName 
		, StopDate DESC
END
