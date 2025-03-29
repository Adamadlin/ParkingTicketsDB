CREATE DATABASE temp_test


CREATE TABLE test (
    VINT INT,
    VDT DATETIME
)


DECLARE @x INT =0;
DECLARE @i int =30000;

SET NOCOUNT ON

DECLARE @1 INT
SET @1 = 30000 -- Replace with your desired number of iterations

WHILE @1 > 0
BEGIN
    INSERT INTO [dbo].[test] (VINT, VDT)
    VALUES (CAST(RAND() * 100000 AS INT), 
    GetDate() + cast (rand()*10000 as int));

    SET @1 = @1 - 1
END

SET NOCOUNT OFF




SET STATISTICS TIME ON

SELECT * 
FROM TEST
WHERE VINT > 97000 AND VDT >= '2026-01-01'
-- HEAP 24 MS TABLE SCAN
-- CLUSTERED SEEK VINT 30 MS 

set showplan_all off




CREATE NONCLUSTERED INDEX [NonClusteredIndex-20250320-192238] ON [dbo].[test]
(
	[VDT] ASC
)
-- USE [temp_test]

-- GO

USE [temp_test];  -- Ensure you're in the correct database (replace with the actual database name)

-- SELECT name, type_desc
-- FROM sys.indexes
-- WHERE object_id = OBJECT_ID('dbo.test') AND name = 'NonClusteredIndex-20250320-192238';

SELECT * FROM sys.indexes





CREATE NONCLUSTERED INDEX [NonClusteredIndex-20250320-180542] ON [dbo].[NewOrdDet]
(	[UnitPrice] ASC )
GO



-- when uisng a heap (non clustered sql ) the system will dress the "FirstIAM" which is the pointer to the adress and will read the data fro there 


execute sp_who





