/*
Lab 1
INFO 445
J. Benjamin Leeds
Created: April 10, 2018
Updated: April 11, 2018

Lab 3 Extra Credit Assignment

Question 1: Quarter with most 300-level classes for departments in A&S btwn 1968 & 1984 THAT ALSO
had at least 200 total classes in 'the quad' btwn 1958 and 1962 (2 queries)

*/

USE UNIVERSITY

-- Presently: counts num A&S classeses in each quarter between 1968 and 1984

SELECT tblCLASS.QuarterID, COUNT(tblCLASS.QuarterID)
FROM tblCollege 
JOIN tblDEPARTMENT ON tblCOLLEGE.CollegeID = tblDEPARTMENT.CollegeID
JOIN tblCOURSE ON tblDEPARTMENT.DeptID = tblCOURSE.DeptID
JOIN tblCLASS ON tblCLASS.CourseID = tblCOURSE.CourseID
WHERE tblCOLLEGE.CollegeName = 'Arts and Sciences'
    AND (tblCLASS.YEAR < 1985 AND tblCLASS.YEAR > 1967)
    AND (tblCOURSE.CourseNumber > 299 and tblCOURSE.CourseNumber < 400)
GROUP BY tblCLASS.QuarterID


/*
    2nd query that returns 1 column (dept. id. = A&S):
*/

-- 1) list of deptIDs in A&S
-- 2) list of course in A&S joined by DeptID
-- 3)

SELECT * FROM tblCOURSE
WHERE tblCOURSE.DeptID IN(
    -- Retrieve list of DeptIDs within the College of A&S
    SELECT tblDEPARTMENT.DeptID FROM tblDEPARTMENT
    JOIN tblCOLLEGE ON tblDEPARTMENT.CollegeID = tblCOLLEGE.CollegeID
    WHERE tblCOLLEGE.CollegeName = 'Arts and Sciences'  
)

/*

Question 2: Determine students w/ at least 2 relationships listed as 'sibling' in addition to having
completed at least 20 credits of 300-level chemistry after 2011

*/

/*

Question 3: 

Determine the most-common dormroom type for students who have special needs of either
'Physical Access' or 'Preparation Accommodation' who completed a business school course 
before 1989 with a grade between 3.4 and 3.8

*/

-- ############################################################################
-- Schema

SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'
SELECT * FROM tblRELATIONSHIP

/* Tables:

tblCLASS_LIST
    ClassID, StudentID, Grade, RegistrationDate

tblCLASS (671,018 Rows)
    ClassID, CourseID, QuarterID, YEAR, ClassroonID, ScheduleID, Section

tblQUARTER
    QuarterName (Winter, Spring, Summer, Autumn)
    QuarterBeginMonth
    QuarterEndMonth

tblLOCATION
    LocationName = 'Liberal Arts Quadrangle ('The Quad')'
    LocationDescription

tblCOURSE
    CourseID
    CourseName
    Credits
    DeptID
    CourseDescription

tblCOLLEGE
    CollegeID
    CollegeName = 'Arts and Sciences'
    CollegeDescr

tblDEPARTMENT
    DeptID
    DeptName e.g. History
    DebtAbbrev e.g. HIST
    CollegeID -> references tblCOLLEGE, can use to find departments in A&S
    DeptDescr

tblRELATIONSHIP
    RelationshipID
    RelationshipName
    RelationshipDescr