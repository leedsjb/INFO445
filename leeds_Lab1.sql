/*
Lab 1
INFO 445
J. Benjamin Leeds
March 28, 2018
*/

PRINT 'Executing Script'
GO

-- new batch --
USE master
-- check if leeds_Lab1 databse exists, if not create it
IF NOT EXISTS(
    SELECT name
    FROM sys.databases
    WHERE name = N'leeds_Lab1'
)
CREATE DATABASE leeds_Lab1
GO -- signals the end of a batch of SQL statements starting after the last GO command

-- new batch --
USE leeds_Lab1 

-- IDENTITY(startingInt, increment): automatically creates a unique INT for primary key fields
IF OBJECT_ID('dbo.tblDOCTORS', 'U') IS NOT NULL
DROP TABLE dbo.tblDOCTORS
GO

CREATE TABLE tblDOCTORS
(
    DoctorID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
    DoctorName varchar(50) not null
);
GO

-- new batch --
BEGIN TRAN G1
INSERT INTO tblDoctors(DoctorName)
VALUES ('Dr. Benjamin'), ('Dr. Greg'), ('Dr. Julian'), ('Dr. Sabrina'), ('Dr. Caitlin')

IF @@ERROR <> 0
    ROLLBACK TRAN G1
ELSE
    COMMIT TRAN

GO

-- new batch --

-- Create a new table called 'tblPATIENTS' in schema 'dbo'
-- Drop the table if it already exists
IF OBJECT_ID('dbo.tblPATIENTS', 'U') IS NOT NULL
DROP TABLE dbo.tblPATIENTS
GO
-- Create the table in the specified schema
CREATE TABLE tblPATIENTS
(
    PatientID int IDENTITY(1,1) PRIMARY KEY NOT NULL, -- primary key column
    PatientName varchar(50) NOT NULL
);
GO

BEGIN TRAN G2
INSERT INTO tblPATIENTS (PatientName)
VALUES ('Jessica'), ('Anushree'), ('Lee'), ('Joe'), ('Royce')
IF @@ERROR <> 0
    ROLLBACK TRAN G2
ELSE
    COMMIT TRAN
GO