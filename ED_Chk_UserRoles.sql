-- Check Roles for every database by specified user
DECLARE @command NVARCHAR(4000) ;
DECLARE @username VARCHAR(MAX);
DECLARE @OutputTable TABLE
(
	  DatabaseName VARCHAR(200) 
	, UserName VARCHAR(200)
	, SchemaName VARCHAR(200) 
	, RolesName VARCHAR(200)
	, CmdDropUser VARCHAR(MAX)
	, CmdCreateUser VARCHAR(MAX)
	, CmdAddMember VARCHAR(MAX) 
	, CmdDropMember VARCHAR(MAX) 
);
BEGIN
	-- Set Username for check
	SET @username = '<loginname,VARCHAR(MAX),login>';

	-- Set SQL Command
	SET @command = 
		'USE [?] ;' +
			'IF ''?'' in (select [name] from sys.databases where [name] not in (''--'')) 
			BEGIN
				SELECT
					d.name as DatabaseName
					, dp.name as UserName 
				, dp.default_schema_name AS SchemaName 
				, RolesName = STRING_AGG(rp.name, '','')
				, CmdDropUser = CONCAT(''USE [?];'',''DROP USER '',QUOTENAME(dp.name),'';'')			
				, CmdCreateUser = CONCAT(''USE [?];'',''CREATE USER '',QUOTENAME(dp.name),'' FOR LOGIN '',QUOTENAME(''' + @username + '''),'';'')
				, CmdAddMember = STRING_AGG(CONCAT(''ALTER ROLE '',QUOTENAME(rp.name),'' ADD MEMBER '',QUOTENAME(dp.name)),'';'')				
				, CmdRemoveMember = STRING_AGG(CONCAT(''ALTER ROLE '',QUOTENAME(rp.name),'' DROP MEMBER '',QUOTENAME(dp.name)),'';'')
				FROM sys.databases AS d
				LEFT OUTER JOIN sys.database_principals AS dp ON dp.sid = SUSER_SID(''' + @username + ''')
				LEFT OUTER JOIN sys.database_role_members AS rm
				ON dp.principal_id = rm.member_principal_id
				LEFT OUTER JOIN sys.database_principals AS rp
				ON rp.principal_id = rm.role_principal_id
				WHERE d.database_id = DB_ID(''?'')
				GROUP BY d.name, dp.name, dp.default_schema_name		
			END'

	INSERT INTO @OutputTable
	EXEC sp_MSforeachdb @command;

	SELECT 
		  DatabaseName 
		, UserName 
		, SchemaName 
		, RolesName  	
		, CASE 
			WHEN UserName IS NULL THEN '--'
			ELSE CmdCreateUser
		END AS CmdCreateUser
		, CASE 
			WHEN RolesName IS NULL THEN '--'
			ELSE CmdAddMember
		END AS CmdAddMember
		, CASE 
			WHEN UserName IS NULL THEN '--'
			ELSE CmdDropUser
		END AS CmdDropUser 
		, CASE 
			WHEN RolesName IS NULL THEN '--'
			ELSE CmdDropMember
		END AS CmdDropMember	
	FROM @OutputTable
	WHERE UserName IS NOT NULL
ORDER BY DatabaseName
END;



