/*

INFO 445
Lab 3 Notes
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

