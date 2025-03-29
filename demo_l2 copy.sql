-- demo 

exec SP_configure 

-- forces SQL Server to show all of its config. options
EXEC sp_configure 'show advanced options' , 1
go
RECONFIGURE WITH OVERRIDE
GO

-- limit the user connections to the SQL to 2000 connections.
EXEC sp_configure 'user connections' , 2000
go
RECONFIGURE WITH OVERRIDE
GO

-- system sp that lists all the current sessions/connections/processes.
exec sp_who
-- global functions that shows the current spid (session id)
select @@spid


exec sp_configure 'max degree of parallelism' , 20
go 
RECONFIGURE WITH OVERRIDE
GO

EXEC sys.sp_configure N'backup compression default', N'1'
GO
EXEC sys.sp_configure N'backup checksum default', N'1'
GO
RECONFIGURE WITH OVERRIDE
GO

EXEC sys.sp_configure N'max server memory (MB)', N'24000'
GO
RECONFIGURE WITH OVERRIDE
GO
-- make index  inserttions/upates run faster with ff < 100%
EXEC sys.sp_configure N'fill factor (%)', N'80'
GO
RECONFIGURE WITH OVERRIDE
GO

exec sp_configure


-- the dangerous cmd shell option ..... (Adam's forbidden apple....)

exec sp_configure 'xp_cmdshell'  , N'1'
GO
RECONFIGURE WITH OVERRIDE
GO

exec xp_cmdshell 'dir C:\SQLCourse\ADMIN\L1'

