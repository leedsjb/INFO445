/*
Lab 2
INFO 445
J. Benjamin Leeds
Created: April 13, 2018
Updated:

*/

IF NOT EXISTS(
    SELECT name
    FROM sys.databases
    WHERE name = N'leeds_Lab2'
)
CREATE DATABASE leeds_Lab2
GO

USE leeds_Lab2
GO

-- check if tables exist, if so drop them so they can be recreated empty

IF OBJECT_ID('dbo.tblPET', 'U') IS NOT NULL
DROP TABLE dbo.tblPET

IF OBJECT_ID('dbo.tblPET_TYPE', 'U') IS NOT NULL
DROP TABLE dbo.tblPET_TYPE

IF OBJECT_ID('dbo.tblCOUNTRY', 'U') IS NOT NULL
DROP TABLE dbo.tblCOUNTRY

IF OBJECT_ID('dbo.tblTEMPERAMENT', 'U') IS NOT NULL
DROP TABLE dbo.tblTEMPERAMENT

IF OBJECT_ID('dbo.tblGENDER', 'U') IS NOT NULL
DROP TABLE dbo.tblGENDER

GO

CREATE TABLE tblPET_TYPE(
    PetTypeID INT IDENTITY(1,1) PRIMARY KEY,
    PetTypeName varchar(50)
)

CREATE TABLE tblCOUNTRY(
    CountryID INT IDENTITY(1,1) PRIMARY KEY,
    CountryName varchar(50)
)

CREATE TABLE tblTEMPERAMENT(
    TempID INT IDENTITY(1,1) PRIMARY KEY,
    TempName varchar(30)
)

CREATE TABLE tblGENDER(
    GenderID INT IDENTITY(1,1) PRIMARY KEY,
    GenderName varchar(20)
)

CREATE TABLE tblPET(
    PetID int IDENTITY(1,1) PRIMARY KEY,
    PetName varchar(30),
    PetTypeID INT FOREIGN KEY REFERENCES tblPET_TYPE,
    CountryID INT FOREIGN KEY REFERENCES tblCOUNTRY,
    TempID INT FOREIGN KEY REFERENCES tblTEMPERAMENT,
    DOB date NOT NULL,
    GenderID INT FOREIGN KEY REFERENCES tblGENDER
)