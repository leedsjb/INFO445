/*
Lab 3 - Synthetic Transaction and Database Backup and Restore 
INFO 445
J. Benjamin Leeds
Created: April 25, 2018
Updated: April 26, 2018
*/

USE master
GO

RESTORE FILELISTONLY
FROM DISK = 'C:\SQL\Lab3_445_Template.bak'

-- Restore full database
RESTORE DATABASE Lab3_445_leeds -- database name
FROM DISK = 'C:\SQL\Lab3_445_Template.bak' -- backup location
WITH 
    MOVE 'Lab3_445' -- move data file to specified dir
    TO 'C:\SQL\Lab3_445_leeds.mdf',
    MOVE 'Lab3_445_log' -- move log file to specified dir
    TO 'C:\SQL\Lab3_445_leeds.ldf',

RECOVERY, REPLACE, STATS
GO
-- STATS: provides incremental update

USE Lab3_445_leeds
GO

IF(OBJECT_ID('uspGetCustID')) IS NOT NULL
    DROP PROCEDURE uspGetCustID;
GO

CREATE PROCEDURE uspGetCustID
    @First VARCHAR(60),
    @Last VARCHAR(60),
    @Birth DATE, 
    @Zip VARCHAR(25), 
    @CustID INTEGER OUTPUT
AS
BEGIN

    SET @CustID = (
        SELECT CustomerID
        FROM tblCUSTOMER
        WHERE CustomerFName = @First
        AND CustomerLName = @Last
        AND DateOfBirth = @Birth
        AND CustomerZip = @Zip
    )
END
GO

IF(OBJECT_ID('uspGetProdID')) IS NOT NULL
    DROP PROCEDURE uspGetProdID;
GO
CREATE PROCEDURE uspGetProdID
    @P_Name VARCHAR(100),
    @P_ID INTEGER OUTPUT
AS
BEGIN
    SET @P_ID = (
        SELECT ProductID
        FROM tblPRODUCT
        WHERE ProductName = @P_Name
    )
END
GO

IF(OBJECT_ID('uspInsertOrder')) IS NOT NULL
    DROP PROCEDURE uspInsertOrder;
GO
-- inserts orders into database based on arguments
CREATE PROCEDURE uspInsertOrder
    @Fname varchar(60),
    @Lname varchar(60),
    @DOB Date,
    @C_Zip varchar(25),
    @Product varchar(100),
    @Qty numeric(5,0),
    @OrderDate Date
    
    AS
        DECLARE @PID INT
        DECLARE @CID INT
        
        -- set orderDate to current date if null
        IF @OrderDate IS NULL
            BEGIN
                SET @OrderDate = (SELECT GetDate())
            END
        
        -- obtain product ID from Product lookup table
        EXEC uspGetProdID
            @P_Name = @Product,
            @P_ID = @PID OUTPUT
        
        EXEC uspGetCustID
            @First = @Fname,
            @Last = @Lname,
            @Birth = @DOB,
            @Zip = @C_Zip,
            @CustID = @CID OUTPUT
        
        IF @CID IS NULL
        BEGIN
            PRINT '@CID IS NULL and will fail on insert statement; process terminated'
            RAISERROR ('CustomerID variable @CID cannot be NULL', 11,1)
            RETURN
        END
        
        IF @PID IS NULL
        BEGIN
            PRINT '@PID IS NULL and will fail on insert statement; process terminated'
            RAISERROR ('ProductID variable @PID cannot be NULL', 11,1)
            RETURN
        END
 
        BEGIN TRAN G1
        INSERT INTO tblORDER (OrderDate, CustomerID, ProductID, Quantity)
        VALUES (@OrderDate, @CID, @PID, @Qty)
        IF @@ERROR <> 0
            ROLLBACK TRAN G1
        ELSE
            COMMIT TRAN G1
GO

IF(OBJECT_ID('uspWrapperProcedure')) IS NOT NULL
    DROP PROCEDURE uspWrapperProcedure
GO
CREATE PROCEDURE uspWrapperProcedure
    @timesToRun INTEGER
AS
    WHILE @timesToRun > 0 
        BEGIN
            EXECUTE uspInsertOrder
                @Fname = 'Logan',
                @Lname = 'Koitzsch',
                @DOB = '1993-07-24',
                @C_Zip = '31769',
                @Product = 'Silver Stainless Steel Cold Cup',
                @Qty = 1,
                @OrderDate = '2018-04-26'
            SET @timesToRun = @timesToRun - 1
            PRINT @timesToRun
        END


-- Backup and Restore

-- Step 4: Take Full Backup
BACKUP DATABASE Lab3_445_leeds
TO DISK = 'C:\SQL\Lab3_445_leeds.bak'
  
-- *************************************************************************************************

-- Nested stored proc tests
SELECT TOP 10 * FROM tblCUSTOMER;
SELECT TOP 10 * FROM tblPRODUCT;
SELECT TOP 20 * FROM tblORDER
ORDER BY OrderDate DESC;

DECLARE @CID INTEGER
DECLARE @PID INTEGER

EXECUTE uspGetProdID
    @P_Name = 'Silver Stainless Steel Cold Cup',
    @P_ID = @PID OUTPUT
        
EXECUTE uspGetCustID
    @First = 'Logan',
    @Last = 'Koitzsch', 
    @Birth = '1993-07-24',
    @Zip = '31769',
    @CustID = @CID OUTPUT


EXECUTE uspInsertOrder
    @Fname = 'Logan',
    @Lname = 'Koitzsch',
    @DOB = '1993-07-24',
    @C_Zip = '31769',
    @Product = 'Silver Stainless Steel Cold Cup',
    @Qty = 1,
    @OrderDate = '2018-04-26'

PRINT @CID + " " + @PID
GO

EXECUTE uspWrapperProcedure
    @timesToRun = 10   

-- utilities
SELECT * FROM sys.procedures
SELECT * FROM sys.tables

-- view all tables and their schema
SELECT COLUMN_NAME, TABLE_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME LIKE 'tbl%'