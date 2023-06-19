-- Kill processes in sleeping status
-- Declare variables
DECLARE 
	  @intUserSpid INT
	, @intHours INT = <Hours, INT, 24>

-- Declare cursor
DECLARE curSpidList CURSOR FAST_FORWARD
FOR
	SELECT 
		SPID
	FROM master.dbo.sysprocesses (NOLOCK)
	WHERE spid > 50 --avoid system threads
	AND status = 'sleeping' -- only sleeping threads
	AND DATEDIFF(HOUR,last_batch,GETDATE()) >= @intHours -- thread sleeping for xx hours
	AND spid <> @@spid -- ignore current spid

-- Open cursor
OPEN @curSpidList

-- Move forward cursor
FETCH NEXT FROM @curSpidList INTO @intUserSpid

-- Cycle record
WHILE (@@FETCH_STATUS=0)
BEGIN
	-- Print kill spid
	PRINT 'Killing '+CONVERT(VARCHAR,@intUserSpid)
	
	-- Kill process
	--EXEC('KILL '+@intUserSpid)
	
	-- Move forward
	FETCH NEXT FROM @curSpidList INTO @intUserSpid
END

-- Close cursor
CLOSE @curSpidList

-- Free memory
DEALLOCATE @curSpidList