/*
    Midterm Review Extra Credit
    Author: J. Benjamin Leeds
    Date Created: Monday April 30, 2018
    Modified:

    Create stored procedure that returns count of # of rooms in a given building with:
        1. if room has air conditioning -> 'OK in summer'
        2. if room has view of Portage Bay -> 'Nice View'
        3. if both 1 & 2 -> 'nice view in summer'
        4. if neither -> 'not a nice place to live'
*/

-- Choose proper database to use w/ USE [dbName]

CREATE PROCEDURE uspBuildingAmenities
    @building NVARCHAR(60)
AS
BEGIN
    SELECT ROOM.CourseName, 'Amenity Description' = 
    CASE Amenity.AmenityID
        WHEN 1 THEN 'nice view in summer'
        WHEN 2 THEN 'OK in summer'
        WHEN 3 THEN 'Nice View'
        ELSE 'not a nice place to live'
    END
    FROM ROOM
    INNER JOIN ROOM_AMENITY on ROOM.RoomID = ROOM_AMENITY.RoomAmenityID
    INNER JOIN AMENITY on ROOM_AMENITY.AmenityID = AMENITY.AmenityID
    WHERE ROOM.BuildingID = ( -- narrow down to specific department
        SELECT BUILDING.BuildingID
        FROM BUILDING
        WHERE BUILDING.BuildingName = @building
    )
    GROUP BY ROOM.RoomName, AMENITY.amenityID;
END;
GO

-- testing with similar tables in UNIVERSITY_NEW database on IS-HAY05

USE UNIVERSITY_NEW;
GO

-- count number of courses taught in summertime (similar to rooms with certain amenities)
SELECT QuarterName, COUNT(tblQUARTER.QuarterName) AS numClasses FROM tblCOURSE
INNER JOIN tblCLASS on tblCOURSE.CourseID = tblCLASS.ClassID
INNER JOIN tblQUARTER on tblCLASS.QuarterID = tblQUARTER.QuarterID
WHERE tblQUARTER.QuarterName IN ('Summer')
GROUP BY tblQUARTER.QuarterName;

SELECT tblCOURSE.CourseName, 
'Description' = 
    CASE tblQUARTER.QuarterID
        WHEN 1 THEN 'summer and spring'
        WHEN 2 THEN 'summer only'
        WHEN 3 THEN 'spring only'
        ELSE 'neither'
    END
FROM tblCOURSE
INNER JOIN tblCLASS on tblCOURSE.CourseID = tblCLASS.ClassID
INNER JOIN tblQUARTER on tblCLASS.QuarterID = tblQUARTER.QuarterID
WHERE tblCOURSE.DeptID = ( -- narrow down to specific department
    SELECT tblDEPARTMENT.DeptID
    FROM tblDEPARTMENT
    WHERE tblDEPARTMENT.DeptName = 'Urban Planning'
)
GROUP BY tblCOURSE.CourseName, tblQUARTER.QuarterID
