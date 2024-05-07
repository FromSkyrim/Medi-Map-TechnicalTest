USE [MediMapPatients];
GO

-- Drop existing tables if they exist
IF OBJECT_ID('dbo.Patient', 'U') IS NOT NULL
    DROP TABLE dbo.Patient;
IF OBJECT_ID('dbo.MedicationAdministration', 'U') IS NOT NULL
    DROP TABLE dbo.MedicationAdministration;
IF OBJECT_ID('dbo.Medication', 'U') IS NOT NULL
    DROP TABLE dbo.Medication;
IF OBJECT_ID('dbo.ErrorLog', 'U') IS NOT NULL
    DROP TABLE dbo.ErrorLog;
GO

-- Create Patient table
CREATE TABLE dbo.Patient
(
    PatientID int NOT NULL,
    FirstName NVARCHAR(40) NOT NULL,
    LastName NVARCHAR(40) NOT NULL,
    Gender NVARCHAR(10) NOT NULL,
    DOB DATETIME NOT NULL,
    HeightCms DECIMAL(4,1) NOT NULL,
    WeightKgs DECIMAL(4,1) NOT NULL,
    PRIMARY KEY CLUSTERED (PatientID)
) ON [PRIMARY];
GO

-- Create MedicationAdministration table
CREATE TABLE dbo.MedicationAdministration
(
    MedicationAdministrationID int IDENTITY(1, 1) NOT NULL,
    PatientID INT NOT NULL,
    Created DATETIME NOT NULL,
    BMI DECIMAL(3,1) NOT NULL,
    PRIMARY KEY CLUSTERED (MedicationAdministrationID)
) ON [PRIMARY];
GO

-- Create Medication table
CREATE TABLE dbo.Medication
(
    MedicationID int NOT NULL,
    MedicationName NVARCHAR(128) NOT NULL,
    PRIMARY KEY CLUSTERED (MedicationID)
) ON [PRIMARY];
GO

-- Create ErrorLog table
CREATE TABLE dbo.ErrorLog
(
    ErrorLogID int IDENTITY(1, 1) NOT NULL,
    ErrorMessage NVARCHAR(4000) NOT NULL,
    PRIMARY KEY CLUSTERED (ErrorLogID)
) ON [PRIMARY];
GO

-- Insert data into Patient table
INSERT INTO dbo.Patient (PatientID, FirstName, LastName, Gender, DOB, HeightCms, WeightKgs)
VALUES
    (1, 'Barbara', 'Smith', 'Female', '1944-08-28', 165, 75.6),
    (2, 'Helen', 'Castillo', 'Female', '1963-10-19', 161, 65),
    (3, 'Ivan', 'Winter', 'Male', '1942-10-12', 175.3, 85);
GO

-- Insert data into Medication table
INSERT INTO dbo.Medication (MedicationID, MedicationName)
VALUES
    (1, 'Laxsol sodium 50 mg + sennoside B 8 mg tablet'),
    (2, 'Ativan 1 mg tablet'),
    (3, 'Abacavir 300 mg tablet'),
    (4, 'Cardizem CD - diltiazem hydrochloride 240 mg capsule: extended release'),
    (5, 'Docusate sodium 50 mg + sennoside B 8 mg tablet');
GO

-- Create or alter stored procedures
CREATE OR ALTER PROCEDURE dbo.uspPatientManage
    @PatientId INT,
    @FirstName NVARCHAR(40),
    @LastName NVARCHAR(40),
    @Gender NVARCHAR(10),
    @DOB DATETIME,
    @HeightCms DECIMAL(4,1),
    @WeightKgs DECIMAL(4,1)
AS 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.Patient WHERE PatientID = @PatientId)
    BEGIN
        INSERT INTO dbo.Patient (PatientID, FirstName, LastName, Gender, DOB, HeightCms, WeightKgs)
        VALUES (@PatientId, @FirstName, @LastName, @Gender, @DOB, @HeightCms, @WeightKgs);
    END
    ELSE
    BEGIN
        UPDATE dbo.Patient
        SET FirstName = @FirstName, LastName = @LastName, Gender = @Gender, DOB = @DOB, HeightCms = @HeightCms, WeightKgs = @WeightKgs
        WHERE PatientID = @PatientId;
    END
END;
GO

CREATE OR ALTER PROCEDURE dbo.uspMedicationAdministration
    @PatientId INT,
    @MedicationId INT,
    @BMI DECIMAL(3,1)
AS 
BEGIN
    DECLARE @CurrentDate DATETIME = GETDATE();
    INSERT INTO dbo.MedicationAdministration (PatientID, Created, BMI)
    VALUES (@PatientId, @CurrentDate, @BMI);
END;
GO

CREATE OR ALTER PROCEDURE dbo.uspLogError
    @ErrorMessage NVARCHAR(4000)
AS 
BEGIN
    INSERT INTO dbo.ErrorLog (ErrorMessage)
    VALUES (@ErrorMessage);
END;
GO
