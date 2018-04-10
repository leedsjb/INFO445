/*

INFO 445
Lab 3
J. Benjamin Leeds

CAST(): command that allows one to change datatypes
e.g. DateTime --> Date or DateTime --> varchar() or Numeric --> INT

DateDiff(): calculate difference between two dates

*/ 

USE UNIVERSITY
GO

-- Part 1

SELECT Top(20) I.InstructorFname, I.InstructorLname, 
    CAST(IIT.BeginDate AS DATE) AS StartDate,
    CAST(IIT.EndDate AS DATE) AS EndDate
FROM tblINSTRUCTOR I
JOIN tblINSTRUCTOR_INSTRUCTOR_TYPE IIT 
ON I.InstructorID = IIT.InstructorTypeID

GO

/* Part 2: calculate duration @ job (which faculty have worked the longest)
    Condition: end date is null
    Problem: cannot perform math on NULL values -> substitute today's date for NULL endDate
*/

SELECT I.InstructorFname, 
    I.InstructorLname, 
    DateDiff(
        YEAR,
        BeginDate,
        ISNULL(IIT.ENDDate, GetDate()) 
    )
FROM tblINSTRUCTOR I
JOIN tblINSTRUCTOR_INSTRUCTOR_TYPE IIT
ON I.InstructorID = IIT.InstructorTypeID
ORDER BY 

GO

/*

Lab 3 Extra Credit Assignment

Question 1: Quarter with most 300-level classes for departments in A&S btwn 1968 & 1984 THAT ALSO
had at least 200 total classes in 'the quad' btwn 1958 and 1962 (2 queries)

SELECT *
FROM tblCollege 
JOIN DEPARTMENT ON
JOIN COURSE ON
JOIN class ON
WHERE collegename = A&S AND Class.Year BETWEEN '1958' AND '1984'
AND 
** 2nd query that returns 1 column (dept. id. = A&S):
DepartmentID in 

    SELECT DeptID FROM 

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

SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'

SELECT * FROM tblRELATIONSHIP

/* Tables:

tblCLASS_LIST
    ClassID, StudentID, Grade, RegistrationDate

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

