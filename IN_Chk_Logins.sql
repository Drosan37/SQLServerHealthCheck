-- Check Login status and instance role
SELECT
	loginname AS 'LoginName'
	, dbname AS 'DatabaseName'	
	, CASE isntname
		WHEN 0 THEN 'SQLServerLogin'
		WHEN 1 THEN 'WindowsLogin'
	END AS LoginType
	, CASE
		WHEN isntname = 0 AND is_policy_checked = 1 THEN 'X'
		WHEN isntname = 0 AND is_policy_checked = 0 THEN ''
		WHEN isntname = 1 THEN 'X'
	END AS PasswordPolicy
	, CASE isntgroup
		WHEN 0 THEN 'User'
		WHEN 1 THEN 'Group'
	END AS UserOrGroup
	, CASE denylogin
		WHEN 0 THEN 'AccessEnabled'
		WHEN 1 THEN 'AccessDisabled'
	END AS UserOrGroup
	, CASE sysadmin
		WHEN 0 THEN ''
		WHEN 1 THEN 'X'
	END AS IsAdmin
	, CASE securityadmin
		WHEN 0 THEN ''
		WHEN 1 THEN 'X'
	END AS IsSecurityAdmin
	, CASE serveradmin
		WHEN 0 THEN ''
		WHEN 1 THEN 'X'
	END AS IsServerAdmin
	, CASE setupadmin
		WHEN 0 THEN ''
		WHEN 1 THEN 'X'
	END AS IsSetupAdmin
	, CASE processadmin
		WHEN 0 THEN ''
		WHEN 1 THEN 'X'
	END AS IsProcessAdmin
	, CASE diskadmin
		WHEN 0 THEN ''
		WHEN 1 THEN 'X'
	END AS IsDiskAdmin
	, CASE dbcreator
		WHEN 0 THEN ''
		WHEN 1 THEN 'X'
	END AS IsDbCreator
	, CASE bulkadmin
		WHEN 0 THEN ''
		WHEN 1 THEN 'X'
	END AS IsBulkAdmin
FROM sys.syslogins lgn
LEFT OUTER JOIN sys.sql_logins sqlgn
ON lgn.sid = sqlgn.sid