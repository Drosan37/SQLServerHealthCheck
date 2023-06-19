-- Check network connection
SELECT 
	  des.login_name
	, des.host_name, program_name
	, dec.net_transport
	, des.login_time
	, e.name AS endpoint_name
	, e.protocol_desc
	, e.state_desc
	, e.is_admin_endpoint
	, t.port
	, t.is_dynamic_port
	, dec.local_net_address
	, dec.local_tcp_port   
FROM sys.endpoints AS e  
LEFT JOIN sys.tcp_endpoints AS t  
   ON e.endpoint_id = t.endpoint_id  
LEFT JOIN sys.dm_exec_sessions AS des  
   ON e.endpoint_id = des.endpoint_id  
LEFT JOIN sys.dm_exec_connections AS dec  
   ON des.session_id = dec.session_id; 