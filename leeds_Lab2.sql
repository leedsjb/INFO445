/*
Lab Assignment 2
Created: Wednesday April 11, 2018
Modified:
Author: J. Benjamin Leeds

*/

CREATE DATABASE TUG
USE TUG
GO

CREATE TABLE tblSTUDENT_TYPE(
    StudentTypeID INT IDENTITY(1,1) PRIMARY KEY,
    StudentTypeName varchar(50) NOT NULL,
    StudentTypeDescr varchar(200) NULL
)
GO

CREATE TABLE tblSTUDENT(
    StudentID INT IDENTITY(1,1) PRIMARY KEY,
    StudentName varchar(50) NOT NULL,
    StudentTypeID INT FOREIGN KEY REFERENCES tblSTUDENT_TYPE(StudentTypeID) NOT NULL,
    StudentDOB date NOT NULL
)
GO

CREATE TABLE tblSKILL_TYPE(
    SkillTypeID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    SkillTypeName varchar(50) NOT NULL,
    SkillTypeDescr varchar(200)

)

CREATE TABLE tblSKILL(
    SkillID INT IDENTITY(1,1) PRIMARY KEY,
    SkillName varchar(50) NOT NULL, 
)
GO

CREATE TABLE tblLEVEL(
    LevelID INT IDENTITY(1,1) PRIMARY KEY,
    LevelName varchar(40) NOT NULL,
    SkillTypeID FOREIGN KEY REFERENCES tblSKILL_TYPE (SkillTypeID) NOT NULL
)
GO

CREATE TABLE tblSTUDENT_SKILL_LEVEL(
    StudentSkillLevelID int IDENTITY(1,1) PRIMARY KEY,
    StudentID FOREIGN KEY REFERENCES tblSTUDENT(StudentID) NOT NULL,
    SkillID FOREIGN KEY REFERENCES tblSKILL(SkillID) NOT NULL,
    LevelID FOREIGN KEY REFERENCES tblLevel(LevelID) NOT NULL
)

-- insert data into tables
-- INSERT INTO tblLEVEL(LevelName)
-- SELECT DISTINCT([Level]) FROM YellowLab

-- INSERT INTO tblSKILL(SkillTypeName)
-- SELECT DISTINCT(SkillType) FROM YellowLab