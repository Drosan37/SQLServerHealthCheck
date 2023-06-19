SELECT	 
	  aolst.dns_name AS ListenerName
	, aoip.ip_address AS IpAddress
	, aoip.ip_subnet_mask AS SubnetMask
	, aoip.network_subnet_ip AS SubnetNetwork
	, aoip.state_desc AS ListenerState
FROM sys.availability_group_listener_ip_addresses aoip
INNER JOIN sys.availability_group_listeners aolst
	ON aoip.listener_id = aolst.listener_id
ORDER BY aolst.dns_name




