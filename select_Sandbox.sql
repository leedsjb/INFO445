-- Erase Database and Start Over

-- DROP TABLE dbo.tblDOCTORS;
-- DROP TABLE dbo.tblPATIENTS;
-- DROP TABLE dbo.tblVISITS;

-- USE leeds_Lab1

-- EXEC sp_stored_procedures N'uspGetDoctorID';

-- #########################################
-- Doctor Related SQL

-- EXECUTE uspGetDoctorID
--     @DoctorFirstName = 'Greg',
--     @DoctorLastName = 'Hay',
--     @DID_outputParameter = OUTPUT

--  SELECT DoctorID
--     FROM tblDOCTORS
--     WHERE DoctorFName = 'Greg' AND DoctorLName = 'Hay'

-- ##########################################
-- Patient Related SQL

-- EXECUTE uspGetPatientID
--     @PatientFirstName = 'Royce',
--     @PatientLastName = 'Le', 
--     @PatientDateOfBirth = '2001-01-10',
--     @PID_outputParameter = @PID OUTPUT

-- EXECUTE uspGetPatientID
-- @PatientFirstName = @PatientFName,
-- @PatientLastName = @PatientLName,
-- @PatientDateOfBirth = @PatientDOB,
-- @PID_outputParameter = @PID OUTPUT

-- ############################################
-- Visit Related SQL

-- EXECUTE uspCreateVisit
--     @DoctorFName = 'Greg',
--     @DoctorLName = 'Hay',
--     @PatientFName = 'Royce',
--     @PatientLName = 'Le', 
--     @PatientDOB = '2001-01-10',
--     @VisitDate = '2018-03-28 16:30:00 -07:00' -- Pacific Daylight Time

EXECUTE uspCreateVisit
    @DoctorFName = 'Benjamin',
    @DoctorLName = 'Leeds',
    @PatientFName = 'Jessica',
    @PatientLName = 'Libman', 
    @PatientDOB = '2007-05-08',
    @VisitDate = '2018-02-28 08:30:00 -07:00' -- Pacific Daylight Time


SELECT * FROM tblDOCTORS;
SELECT * FROM tblPATIENTS;
SELECT * FROM dbo.tblVISITS;

CREATE TABLE tblTEST(
    testID INT IDENTITY(1,1) PRIMARY KEY, 
    foreignKeyID INT FOREIGN KEY REFERENCES tblDoesNotExist
)