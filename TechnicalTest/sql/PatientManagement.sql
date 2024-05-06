
IF OBJECT_ID('dbo.Patient') IS NOT NULL
BEGIN
	DROP TABLE dbo.Patient
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE dbo.Patient
(
	PatientID int NOT NULL,
	FirstName NVARCHAR(40) NOT NULL,
	LastName NVARCHAR(40) NOT NULL,
	Gender NVARCHAR(10) NOT NULL,
	DOB DATETIME NOT NULL,
	HeightCms DECIMAL(4,1) NOT NULL,
	WeightKgs DECIMAL(4,1) NOT NULL
	PRIMARY KEY CLUSTERED 
	(
		PatientID ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


IF OBJECT_ID('dbo.MedicationAdministration') IS NOT NULL
BEGIN
	DROP TABLE dbo.MedicationAdministration
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE dbo.MedicationAdministration
(
	MedicationAdministrationID int IDENTITY(1, 1) NOT NULL,
	PatientID INT NOT NULL,
	Created DATETIME NOT NULL,
	BMI DECIMAL(3,1) NOT NULL,
	PRIMARY KEY CLUSTERED 
	(
		MedicationAdministrationID ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


 USE [TechTestDb]

IF OBJECT_ID('dbo.Medication') IS NOT NULL
BEGIN
	DROP TABLE dbo.Medication
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE dbo.Medication
(
	MedicationID int NOT NULL,
	MedicationName NVARCHAR(128) NOT NULL,
	PRIMARY KEY CLUSTERED 
	(
		MedicationID ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


IF OBJECT_ID('dbo.ErrorLog') IS NOT NULL
BEGIN
	DROP TABLE dbo.ErrorLog
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE dbo.ErrorLog
(
	ErrorLogID int IDENTITY(1, 1) NOT NULL,
	ErrorMessage nvarchar(4000) NOT NULL,
	PRIMARY KEY CLUSTERED 
	(
		ErrorLogID ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


INSERT INTO [dbo].[Patient]
VALUES
           (1
           ,'Barbara'
           ,'Smith'
           ,'Female'
           ,'1944-08-28'
           ,165
           ,75.6)

INSERT INTO [dbo].[Patient]
VALUES
           (2
           ,'Helen'
           ,'Castillo'
           ,'Female'
           ,'1963-10-19'
           ,161
           ,65)

INSERT INTO [dbo].[Patient]
VALUES
           (3
           ,'Ivan'
           ,'Winter'
           ,'Male'
           ,'1942-10-12'
           ,175.3
           ,85)


INSERT INTO [dbo].[Medication]
VALUES
           (1
           ,'Laxsol sodium 50 mg + sennoside B 8 mg tablet'
		   )
INSERT INTO [dbo].[Medication]
VALUES
           (2
           ,'Ativan 1 mg tablet'
		   )  
INSERT INTO [dbo].[Medication]
VALUES
           (3
           ,'Abacavir 300 mg tablet'
		   )  

INSERT INTO [dbo].[Medication]
VALUES
           (4
           ,'Cardizem CD - diltiazem hydrochloride 240 mg capsule: extended release'
		   )  
INSERT INTO [dbo].[Medication]
VALUES
           (5
           ,'Docusate sodium 50 mg + sennoside B 8 mg tablet'
		   )  

GO



SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER PROCEDURE dbo.uspPatientManage
@PatientId INT = NULL,
@FirstName NVARCHAR(40),
@LastName NVARCHAR(40),
@Gender NVARCHAR(10),
@DOB DATETIME,
@HeightCms DECIMAL(4,1),
@WeightKgs DECIMAL(4,1)
AS 
BEGIN


	/*
		This procedure receives data from the API tier that will insert a new patient record or update an existing patient record.
	*/
	    IF NOT EXISTS (SELECT 1 FROM dbo.Patient WHERE PatientID = @PatientID)
    BEGIN
        INSERT INTO dbo.Patient (PatientID, FirstName, LastName, Gender, DOB, HeightCms, WeightKgs)
        VALUES (@PatientID, @FirstName, @LastName, @Gender, @DOB, @HeightCms, @WeightKgs)
    END
    ELSE
    BEGIN
        UPDATE dbo.Patient
        SET FirstName = @FirstName, LastName = @LastName, Gender = @Gender, DOB = @DOB, HeightCms = @HeightCms, WeightKgs = @WeightKgs
        WHERE PatientID = @PatientID
    END
END
go



SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO
CREATE OR ALTER PROCEDURE dbo.uspMedicationAdministration
@PatientId INT,
@MedicationId INT,
@BMI DECIMAL(3,1)
AS 
BEGIN


	/*
		This procedure receives data from the API tier that will insert a new Medication being administered to an existing patient.
	*/
	DECLARE @CurrentDate DATETIME = GETDATE();
    INSERT INTO dbo.MedicationAdministration (PatientID, Created, BMI)
    VALUES (@PatientID, @CurrentDate, @BMI)

END
go
CREATE or ALTER   PROCEDURE [dbo].[uspLogError]
@ErrorLogId INT,
@ErrorMessage NVARCHAR(4000)

AS 
BEGIN

	/*
		This procedure will insert an error message log.
	*/
	INSERT INTO dbo.ErrorLog (ErrorMessage)
    VALUES (@ErrorMessage)

END
go

