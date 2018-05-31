/*
Lab 5 - Final Exam Practice
INFO 445
J. Benjamin Leeds
Created: May 31, 2018
Updated: 

Using the ERD on the study guide, write the SQL code to answer the following questions:

1. Write the stored procedure to populate one row in SEAT_PLANE table using the following:
a) Nested stored procedures to obtain SeatID, PlaneID and ClassID
b) Error-handling for any required values that are NULL
c) Explicit transaction

*/

CREATE DATABASE leeds_airline_db;

USE leeds_airline_db;
GO

CREATE TABLE tblSEAT_TYPE(
    SeatTypeID INTEGER IDENTITY(1,1) PRIMARY KEY,
    SeatTypeName NVARCHAR(25), 
    SeatTypeDescr NVARCHAR(100)
);

CREATE TABLE tblSEAT(
    SeatID INTEGER IDENTITY(1,1) PRIMARY KEY, 
    SeatName NVARCHAR(25),
    SeatTypeID INTEGER FOREIGN KEY REFERENCES tblSEAT_TYPE.SeatTypeID,
    SeatDescr NVARCHAR(100)
); 


-- SeatID nested sproc
CREATE PROCEDURE uspGetSeatIDByName
    @seatName NVARCHAR(25)
AS
BEGIN
    SELECT SEAT.seatID
    FROM tblSEAT
    WHERE SEAT.SeatName LIKE '%' + @seatName + '%';
END;


CREATE PROCEDURE uspPopulateSeat
AS
BEGIN

    BEGIN TRANSACTION T1;

    SELECT * FROM tblFLIGHT_SEAT;

    IF ERROR <> 0
    ROLLBACK;

    COMMIT TRANSACTION T1;


END;

/*
2. Write the SQL code to create a computed column to track the total number of bookings
for each customer
*/

/*
3. Write the SQL code to enforce the following business rule:
"No employee younger than 21 may be scheduled on a flight as crew chief"
*/

/*
4. Write the SQL code to determine which customers have had at least 3 flights to SEATAC airport 
since May 4, 2011 who have also had no more than 7 flights to Seoul/Inchon since November 12, 2010.
*/