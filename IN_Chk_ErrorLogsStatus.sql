DECLARE 
	  @ErrorLogSize int
	, @NumErrorLogs int

EXEC xp_instance_regread N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'ErrorLogSizeInKb', @ErrorLogSize output
EXEC xp_instance_regread N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'NumErrorLogs', @NumErrorLogs output

PRINT 'NumLogs: ' + CAST(@NumErrorLogs AS VARCHAR) + ' - ErrorLogSize: ' + CAST(@ErrorLogSize AS VARCHAR) + 'KB'




--USE [master]
--GO
--EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'ErrorLogSizeInKb', REG_DWORD, 20000
--GO
--EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'NumErrorLogs', REG_DWORD, 10
--GO
