/*
Lab 1
INFO 445
J. Benjamin Leeds
Created: March 27, 2018
Updated: March 28, 2018
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
    DoctorFName varchar(50) not null,
    DoctorLName varchar(50) not null
);
GO

-- new batch --
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

-- -- Create a new table called 'tblVISITS' in schema 'dbo'
-- -- Drop the table if it already exists
-- IF OBJECT_ID('dbo.tblVISITS', 'U') IS NOT NULL
-- DROP TABLE dbo.tblVISITS
-- GO
-- -- Create the table in the specified schema
-- CREATE TABLE tblVISITS
-- (
--     VisitId INT IDENTITY(1,1) PRIMARY KEY NOT NULL, -- primary key column
--     VisitDate DATETIMEOFFSET NOT NULL,
--     DoctorID INT FOREIGN KEY REFERENCES tblDOCTORS(DoctorID),
--     PatientID INT FOREIGN KEY REFERENCES tblPATIENTS(PatientID)
-- );
-- GO

-- BEGIN TRAN G3 