/*
Lab 1
INFO 445
J. Benjamin Leeds
Created: March 27, 2018
Updated: March 28, 2018
*/

PRINT 'Executing Script'
GO

USE master

-- check if leeds_Lab1 databse exists, if not create it
IF NOT EXISTS(
    SELECT name
    FROM sys.databases
    WHERE name = N'leeds_Lab1'
)
CREATE DATABASE leeds_Lab1
GO -- signals the end of a batch of SQL statements starting after the last GO command

USE leeds_Lab1 
GO

/* 
    Drop table called 'dbo.tblVISITS if it already exists
    Must be dropped here because database integrity prevents dbo.tblDOCTORS from being dropped
    if dbo.tblVISITS exists as tblVISITS has foreign keys pointing to both tblDOCTORS and 
    tblPATIENTS
*/
IF OBJECT_ID('dbo.tblVISITS', 'U') IS NOT NULL
DROP TABLE dbo.tblVISITS
GO


IF OBJECT_ID('dbo.tblDOCTORS', 'U') IS NOT NULL
DROP TABLE dbo.tblDOCTORS
GO

CREATE TABLE tblDOCTORS
(
    -- IDENTITY(startingInt, increment): automatically creates a unique INT for primary key fields
    DoctorID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
    DoctorFName varchar(50) not null,
    DoctorLName varchar(50) not null
);
GO

BEGIN TRAN G1
INSERT INTO tblDoctors(DoctorFName,DoctorLName)
VALUES 
    ('Benjamin','Leeds'), ('Greg','Hay'), ('Julian','Bossiere'),
    ('Sabrina','Niklaus'), ('Caitlin','Schaeffer')

IF @@ERROR <> 0
    ROLLBACK TRAN G1
ELSE
    COMMIT TRAN

GO

-- Create a new table called 'tblPATIENTS' in schema 'dbo'
-- Drop the table if it already exists
IF OBJECT_ID('dbo.tblPATIENTS', 'U') IS NOT NULL
DROP TABLE dbo.tblPATIENTS
GO

-- Create the table in the specified schema
CREATE TABLE tblPATIENTS
(
    PatientID int IDENTITY(1,1) PRIMARY KEY NOT NULL, -- primary key column
    PatientFName varchar(50) NOT NULL,
    PatientLName varchar(50) NOT NULL,
    PatientDOB date NOT NULL
);
GO

BEGIN TRAN G2
INSERT INTO tblPATIENTS (PatientFName, PatientLName, PatientDOB)
VALUES 
    ('Jessica','Libman','2007-05-08'), ('Anushree','Shukla','2007-05-09'),
    ('Lee','Segal','2001-05-08'), ('Joe','Pollock','1995-05-08'), ('Royce','Le','2001-01-10')
IF @@ERROR <> 0
    ROLLBACK TRAN G2
ELSE
    COMMIT TRAN
GO

-- TRANSACTIONAL TABLE AND STORED PROCEDURES --

-- Doctor Lookup Stored Procedure

-- check if uspGetDoctorID stored procedure already exists and if so drop it
IF(OBJECT_ID('uspGetDoctorID')) IS NOT NULL
    DROP PROCEDURE uspGetDoctorID;
GO

CREATE PROCEDURE uspGetDoctorID
    (
        @DoctorFirstName varchar(50),
        @DoctorLastName varchar(50),
        @DID_outputParameter INT OUTPUT
    )

AS

SET @DID_outputParameter = (
    SELECT DoctorID
    FROM tblDOCTORS
    WHERE DoctorFName = @DoctorFirstName AND DoctorLName = @DoctorLastName
)

GO

-- Patient Lookup Stored Procedure

IF(OBJECT_ID('uspGetPatientID')) IS NOT NULL
    DROP PROCEDURE uspGetPatientID;
GO

CREATE PROCEDURE uspGetPatientID
    (
        @PatientFirstName varchar(50),
        @PatientLastName varchar(50),
        @PatientDateOfBirth date,
        @PID_outputParameter INT OUTPUT   
    )
 
AS

SET @PID_outputParameter = (
    SELECT PatientID
    FROM tblPATIENTS
    WHERE PatientFName = @PatientFirstName 
    AND PatientLName = @PatientLastName AND PatientDOB = @PatientDateOfBirth
)

GO

-- Create a new table called 'tblVISITS' in schema 'dbo'

-- Create the table in the specified schema
CREATE TABLE tblVISITS
(
    VisitId INT IDENTITY(1,1) PRIMARY KEY NOT NULL, -- primary key column
    VisitDate DATETIMEOFFSET NOT NULL,
    DoctorID INT FOREIGN KEY REFERENCES tblDOCTORS(DoctorID) NOT NULL,
    PatientID INT FOREIGN KEY REFERENCES tblPATIENTS(PatientID) NOT NULL
);
GO

/*
Create a stored procedure to populate the transactional table that tracks visits between
doctors and patients with DoctorFName, DoctorLName, PatientFName, PatientLName, PatientDOB
and VisitDate as input parameters. This stored procedure should nest the other two stored
procedures to get doctor and patient IDs, then insert a single record in an explicit transaction.
*/

IF(OBJECT_ID('uspCreateVisit')) IS NOT NULL
    DROP PROCEDURE uspCreateVisit;
GO

CREATE PROCEDURE uspCreateVisit
    (
        @DoctorFName varchar(50),
        @DoctorLName varchar(50),
        @PatientFName varchar(50),
        @PatientLName varchar(50),
        @PatientDOB date,
        @VisitDate DateTimeOffset
    )
AS

BEGIN

    DECLARE @PID INT -- patient ID variable
    DECLARE @DID INT -- doctor ID variable

    EXECUTE uspGetDoctorID
    @DoctorFirstName = @DoctorFName,
    @DoctorLastName = @DoctorLName,
    @DID_outputParameter = @DID OUTPUT


    EXECUTE uspGetPatientID
    @PatientFirstName = @PatientFName,
    @PatientLastName = @PatientLName,
    @PatientDateOfBirth = @PatientDOB,
    @PID_outputParameter = @PID OUTPUT

    IF @PID IS NULL
        PRINT 'Patient Not Found'

    IF @DID IS NULL
        PRINT 'Doctor Not Found'

    -- check to ensure PID and DID are not null before INSERT
    IF (@PID IS NOT NULL AND @DID IS NOT NULL)
        INSERT INTO dbo.tblVISITS(VisitDate, DoctorID, PatientID)
        VALUES (@VisitDate, @DID, @PID)

END;

GO

  -- DateTimeOffset Format: 1900-01-01 00:00:00 00:00