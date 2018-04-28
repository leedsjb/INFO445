/*
Lab 3 - Synthetic Transaction and Database Backup and Restore 
INFO 445
J. Benjamin Leeds
Created: April 25, 2018
Updated: April 27, 2018
*/

USE master
GO

RESTORE FILELISTONLY
FROM DISK = 'C:\SQL\Lab3_445_Template.bak';

-- Restore full database
RESTORE DATABASE Lab3_445_leeds -- database name
FROM DISK = 'C:\SQL\Lab3_445_Template.bak' -- backup location
WITH 
    MOVE 'Lab3_445' -- move data file to specified dir
    TO 'C:\SQL\Lab3_445_leeds.mdf',
    MOVE 'Lab3_445_log' -- move log file to specified dir
    TO 'C:\SQL\Lab3_445_leeds.ldf',
RECOVERY, REPLACE, STATS;
GO
-- STATS: provides incremental update

USE Lab3_445_leeds;
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
BEGIN

    DECLARE @numCustomers   INTEGER;
    DECLARE @numProducts    INTEGER;
    DECLARE @randCustomerID INTEGER;
    DECLARE @randProductID  INTEGER;
    DECLARE @Fname          VARCHAR(60);
    DECLARE @Lname          VARCHAR(60);
    DECLARE @DOB            DATE;
    DECLARE @C_Zip          VARCHAR(25);
    DECLARE @Product        VARCHAR(100);
    DECLARE @Qty            NUMERIC
    DECLARE @OrderDate      DATETIME;
    SET @numCustomers = (SELECT COUNT(*) FROM tblCUSTOMER);
    SET @numProducts = (SELECT COUNT(*) FROM tblPRODUCT);

    WHILE @timesToRun > 0 
    BEGIN

        -- calculate random customerID within range of products
        SET @numCustomers = (SELECT COUNT(*) FROM tblCUSTOMER);
        SET @randCustomerID = (RAND() * @numCustomers);

        -- ensure randCustomerID is never 0
        IF @randCustomerID < 1
            SET @randCustomerID = 1;

        SELECT
            @Fname = CustomerFName, @Lname = CustomerLname,
            @DOB = DateOfBirth, @C_Zip = CustomerZIP
        FROM tblCUSTOMER
        WHERE CustomerID = @randCustomerID;

        -- calculate random productID within range of products
        SET @numProducts = (SELECT COUNT(*) FROM tblPRODUCT);
        SET @randProductID = (RAND() * @numProducts);
        
        -- ensure product ID is never 0
        IF @randProductID < 1
            SET @randProductID = 1;
        
        -- retrieve product name associated with rand product id
        SET @Product = (
            SELECT ProductName
            FROM tblPRODUCT
            WHERE tblPRODUCT.ProductID = @randProductID
        );

        -- generate random order quantity between 0 and 10 (inclusive)
        SET @Qty = (RAND() * 10);
    
        -- generate random order datetime within the preceding 90 days
        SET @OrderDate = DATEADD(minute, RAND() * -90*24*60, GETDATE());
    
        EXECUTE uspInsertOrder
            @Fname = @Fname,
            @Lname = @Lname,
            @DOB = @DOB,
            @C_Zip = @C_Zip,
            @Product = @Product,
            @Qty = @Qty,
            @OrderDate = @OrderDate;

        SET @timesToRun = @timesToRun - 1;
    END;
END;

-- Backup and Restore

-- Step 4: Take Full Backup
BACKUP DATABASE Lab3_445_leeds
TO DISK = 'C:\SQL\Lab3_445_leeds.bak';

-- Step 5: Call wrapper stored procedure 1000 times
EXECUTE uspWrapperProcedure
    @timesToRun = 1000;

-- Step 6: Perform differential backup
BACKUP DATABASE Lab3_445_leeds
TO DISK = 'C:\SQL\Lab3_445_leeds.bak'
WITH DIFFERENTIAL;

-- Step 7: Perform transaction log backup
BACKUP LOG Lab3_445_leeds
TO DISK = 'C:\SQL\Lab3_445_leeds.bak';

-- Step 8: Perform log/differential backup while running synthetics txn in-between

EXECUTE uspWrapperProcedure
    @timesToRun = 75;
BACKUP DATABASE Lab3_445_leeds
TO DISK = 'C:\SQL\Lab3_445_leeds.bak'
WITH DIFFERENTIAL;

EXECUTE uspWrapperProcedure
    @timesToRun = 50;
BACKUP LOG Lab3_445_leeds
TO DISK = 'C:\SQL\Lab3_445_leeds.bak';

EXECUTE uspWrapperProcedure
    @timesToRun = 25;
BACKUP LOG Lab3_445_leeds
TO DISK = 'C:\SQL\Lab3_445_leeds.bak';

EXECUTE uspWrapperProcedure
    @timesToRun = 100;
BACKUP DATABASE Lab3_445_leeds 
TO DISK = 'C:\SQL\Lab3_445_leeds.bak'
WITH DIFFERENTIAL;

EXECUTE uspWrapperProcedure
    @timesToRun = 60;
BACKUP LOG Lab3_445_leeds
TO DISK = 'C:\SQL\Lab3_445_leeds.bak';

GO

-- Step 9: Drop Database
USE MASTER;
DROP DATABASE Lab3_445_leeds;
GO

-- Step 10: View Available Backups and Restore Full Database
RESTORE HEADERONLY FROM DISK = 'C:\SQL\Lab3_445_leeds.bak'; -- show available backups
RESTORE FILELISTONLY FROM DISK = 'C:\SQL\Lab3_445_leeds.bak';

-- Restore from last full backup
RESTORE DATABASE Lab3_445_leeds_restored
FROM DISK = 'C:\SQL\Lab3_445_leeds.bak'
WITH
    MOVE 'Lab3_445' TO 'C:\SQL\Lab3_445_leeds_restored_data.mdf',
    MOVE 'Lab3_445_log' TO 'C:\SQL\Lab3_445_leeds_restored_log.mdf',
    FILE = 3, -- last full backup in HEADERONLY query
    NORECOVERY, REPLACE, STATS;

-- Restore from last differential back
RESTORE DATABASE Lab3_445_leeds_restored
FROM DISK = 'C:\SQL\Lab3_445_leeds.bak'
WITH
    FILE = 8, -- most recent differential backup in HEADERONLY query
    NORECOVERY;

-- Restore sequential transaction log backups following most recent differential backup
RESTORE DATABASE Lab3_445_leeds_restored
FROM DISK = 'C:\SQL\Lab3_445_leeds.bak'
WITH
    FILE = 9, -- only transaction log backup between last differential and current state
    RECOVERY;
    
-- Select recently restored database
USE Lab3_445_leeds_restored;
GO

-- Verify most recent orders were restored
SELECT TOP(10) * FROM tblORDER
ORDER BY OrderDate DESC;

-- Step 11: Restore to point in time specified by instructor

/* 
    Steps: repeat steps above but instead restore to most recent differential backup and then 
    restore sequential transaction log backups up until the desired recovery point
*/
