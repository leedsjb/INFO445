/*
SQL Reference
INFO 445
J. Benjamin Leeds
Created: April 13, 2018
Updated:

Note: Unless otherwise specified these SQL queries are for T-SQL

*/



-- List all stored procedures
USE leeds_Lab2
SELECT * FROM sys.procedures

-- Display TOP N results from query
SELECT TOP([N]) * FROM [dbo.tblName]
