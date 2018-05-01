/*

    Midterm Review Extra Credit
    Author: J. Benjamin Leeds
    Date Created: Monday April 30, 2018
    Modified:

    Create stored procedure returns count of # of rooms in a specific building with:
        1. if building has air conditioning -> 'OK in summer'
        2. if building has view of Portage Bay -> 'Nice View'
        3. if both 1 & 2 -> 'nice view in summer'
        4. if neither -> 'not a nice place to live'
    
    list of amenities

    location -> building -> identities
    Get buildingID
    Get amenities

*/

USE UNIVERSITY;

SELECT * FROM tblBUILDING;
SELECT * FROM tblBUILDING_TYPE;

CREATE PROCEDURE uspBuildingAmenities
    field type OUTPUT

AS
BEGIN

END
GO;

SELECT * FROM sys.tables


SELECT TOP(10) * FROM tblDORMROOM;
SELECT TOP(10) * FROM tblDORMROOM_TYPE;

SELECT TOP(10) * from tblCLASSROOM

