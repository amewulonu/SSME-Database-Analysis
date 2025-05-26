-- CREATE a database called medical.
CREATE DATABASE medicals_DB;

GO
-- Use database
USE medicals_DB

Go
-- Create a Table called dbo.medicals with columns.
CREATE TABLE dbo.medicals (
StudentID INT NOT NULL PRIMARY KEY,
Age INT NOT NULL,
Gender VARCHAR (6) NULL,
Height Decimal (6, 2) NULL,
Weight Decimal (6, 2) NULL,
BloodType VARCHAR (3) NULL,
BMI DECIMAL (5, 2) NULL,
Temperation DECIMAL (4, 1) NULL,
HeartRate INT NULL,
BloodPressure INT NULL,
Cholesterol VARCHAR (10) NULL,
Diabetes VARCHAR (3) NULL,
Smoking VARCHAR (3) NULL
);

GO
-- Bulk insert file from csv
BULK INSERT dbo.medicals
	FROM 'C:\Users\amyew\OneDrive\Documents\Portfolio projects\Mentor_proj_SSME_SQL\medical_students_dataset.csv'
	WITH (
	FORMAT = 'CSV',
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '/n',
	TABLOCK
);

GO
-- Create procedure that gets students with height above 160
CREATE PROCEDURE usp_GetTallStudents
	@MinHeight DECIMAL (6,2) = 160 
AS
BEGIN
	SELECT * 
	FROM dbo.medicals
	WHERE Height > @MinHeight;
END;

GO
-- Use subquery to find students with height above 160
SELECT *
FROM dbo.medicals
WHERE StudentID IN (
	SELECT StudentID
	FROM dbo.medicals
	WHERE Height > 160
	);

	GO
-- Use CTE to rank students by BMI within each gender
WITH RankedStudents AS (
	SELECT *,
		Row_Number() OVER (ORDER BY Gender, BMI DESC) AS Rank
		FROM dbo.medicals
)
SELECT *
FROM RankedStudents;

GO
-- Create temporary view for students with medical conditions.
CREATE TEMP VIEW dbo.StudentsWithMedicalConditions AS
	SELECT * 
	FROM dbo.medicals
	WHERE DIabetes = 'Yes'
	OR Smoking = 'Yes'
	OR Cholesterol IN ('High', 'Borderline')
	OR BloodPressure > 130;

GO
-- Count by BloodGroup
SELECT 
	BlooType,
COUNT (*) As CountPerBloodGroup
FROM dbo.medicals
GROUP BY BloodType;

GO
-- Use CTE to Rank Students by Weight within each Gender 
WITH RankedWeights AS (
	SELECT
	StudentID,
	Gender,
	Weight
	Row_Number () Over (Order By Gender, Weight DESC) AS Weight Rank
	FROM dbo.medicals
)
-- Select only the top-ranked student('s) per Gender
SELECT
	StudentID,
	Gender,
	Weight
FROM
	RankedWeights
WHERE
	WeightRank = 1

GO
--Create an index to speed up queries filtering by Gender and Blood type
CREATE INDEX IX_Medicals_Gender_BloodType
ON dbo.medicals (Gender, BloodType);

-- To optimize query that filters both columns
SELECT *
FROM dbo.medicals
WHERE Gender = 'Female' AND BloodType = 'O+';

-- Query filtering by Gender and/or BloodType
SELECT StudentID, Age, BMI
FROM dbo.medical
WHERE Gender = 'Male' AND BloodType = 'A+'; 

GO
-- Students whose Ages are below the overall average using subquery
SELECT 
    StudentID,
    Age,
    Gender,
    BloodType
FROM dbo.medicals
WHERE Age < (
	SELECT AVG(Age)
	FROM dbo.medicals
);
GO
 



