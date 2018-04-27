/*
SQL Reference
INFO 445
J. Benjamin Leeds
Created: April 13, 2018
Updated:

Note: Unless otherwise specified these SQL queries are for T-SQL

*/


-- View all tables
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'

-- List all stored procedures
USE leeds_Lab2
SELECT * FROM sys.procedures

-- List column names and types of all table starting with 'tbl'
SELECT COLUMN_NAME, TABLE_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME LIKE 'tbl%'

-- Display TOP N results from query
SELECT TOP([N]) * FROM [dbo.tblName]
