/*
SQL Reference
INFO 445
J. Benjamin Leeds
Created: April 13, 2018
Updated: Friday April 27, 2018

Note: Unless otherwise specified these SQL queries are for T-SQL

*/

-- view all databases
SELECT name, database_id, create_date  
FROM sys.databases
ORDER BY name DESC;

-- select database to use BEFORE running queries below
USE Lab3_445_leeds

-- View all tables
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'
-- OR w/ all details
SELECT * FROM sys.tables

-- List all stored procedures
SELECT * FROM sys.procedures

-- List column names and types of all table starting with 'tbl'
SELECT COLUMN_NAME, TABLE_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME LIKE 'tbl%'

-- Display TOP N results from query
SELECT TOP([N]) * FROM [dbo.tblName]

-- Display all constraints in database:
SELECT * FROM sys.objects WHERE type_desc LIKE '%CONSTRAINT';

-- Display active connections to databases
EXECUTE sp_who;