-- This will run on MySQL


-- Create the Database
CREATE DATABASE UKHealthDB;
USE UKHealthDB;

-- Create Country Table
CREATE TABLE Country (
    CountryID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL
);

-- Create Minister Table
CREATE TABLE Minister (
    MinisterID INT AUTO_INCREMENT PRIMARY KEY,
    MinisterName VARCHAR(100) NOT NULL,
    Statement TEXT NOT NULL,
    CountryID INT,
    FOREIGN KEY (CountryID) REFERENCES Country(CountryID)
);

-- Create County Table
CREATE TABLE County (
    CountyID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    CountryID INT,
    FOREIGN KEY (CountryID) REFERENCES Country(CountryID)
);

-- Create District Table
CREATE TABLE District (
    DistrictID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    CountyID INT,
    FOREIGN KEY (CountyID) REFERENCES County(CountyID)
);

-- Create EmploymentCategory Table
CREATE TABLE EmploymentCategory (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL
);

-- Create Patient Table
CREATE TABLE Patient (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Age INT NOT NULL,
    DistrictID INT,
    CategoryID INT,
    FOREIGN KEY (DistrictID) REFERENCES District(DistrictID),
    FOREIGN KEY (CategoryID) REFERENCES EmploymentCategory(CategoryID)
);

-- Create PurposeType Table
CREATE TABLE PurposeType (
    PurposeID INT AUTO_INCREMENT PRIMARY KEY,
    PurposeName VARCHAR(100) NOT NULL
);

-- Create Admission Table
CREATE TABLE Admission (
    AdmissionID INT AUTO_INCREMENT PRIMARY KEY,
    AdmissionDate DATE NOT NULL,
    WaitTimes INT NOT NULL,
    PatientID INT,
    PurposeID INT,
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    FOREIGN KEY (PurposeID) REFERENCES PurposeType(PurposeID)
);

-- Create WaitList View (This is just a view, not a table)
CREATE VIEW WaitList AS
SELECT 
    d.Name AS District,
    c.Name AS County,
    co.Name AS Country,
    p.FirstName AS PatientFirstName,
    p.LastName AS PatientLastName,
    p.Age AS PatientAge,
    a.WaitTimes,
    pt.PurposeName
FROM Admission a
JOIN Patient p ON a.PatientID = p.PatientID
JOIN PurposeType pt ON a.PurposeID = pt.PurposeID
JOIN District d ON p.DistrictID = d.DistrictID
JOIN County c ON d.CountyID = c.CountyID
JOIN Country co ON c.CountryID = co.CountryID;

-- Insert into Country (only UK countries)
INSERT INTO Country (Name) VALUES 
('England'),
('Wales'),
('Scotland'),
('Northern Ireland');

-- Insert into Minister
INSERT INTO Minister (MinisterName, Statement, CountryID) VALUES 
('John Harris', 'We aim to reduce waiting times significantly in England.', 1),
('Dafydd Evans', 'Improving healthcare access across Wales.', 2),
('Fiona MacLeod', 'Reducing the backlog of surgeries in Scotland.', 3),
('Patrick O’Neill', 'Enhancing patient care services in Northern Ireland.', 4);

-- Insert into County
INSERT INTO County (Name, CountryID) VALUES 
('Greater London', 1),
('Greater Manchester', 1),
('West Midlands', 1),
('Glasgow City', 3),
('Cardiff', 2),
('Belfast', 4),
('Merseyside', 1),
('South Yorkshire', 1),
('West Yorkshire', 1),
('Tyne and Wear', 1),
('Edinburgh', 3),
('Swansea', 2),
('Aberdeen', 3),
('Derry', 4),
('Fife', 3);

-- Insert into District
INSERT INTO District (Name, CountyID) VALUES 
('City of London', 1),
('Manchester Central', 2),
('Birmingham South', 3),
('Glasgow North', 4),
('Cardiff West', 5),
('Belfast East', 6),
('Liverpool Central', 7),
('Sheffield South', 8),
('Leeds West', 9),
('Newcastle East', 10),
('Edinburgh Central', 11),
('Swansea South', 12),
('Aberdeen North', 13),
('Derry Central', 14),
('Fife North', 15);

-- Insert into EmploymentCategory
INSERT INTO EmploymentCategory (CategoryName) VALUES 
('Employed'),
('Self-employed'),
('Unemployed'),
('Student'),
('Pensioner'),
('Child'),
('Professional'),
('Retired'),
('Part-time'),
('Contractor'),
('Freelancer'),
('Disabled'),
('Volunteer'),
('Intern'),
('Apprentice');

-- Insert into Patient
INSERT INTO Patient (FirstName, LastName, Age, DistrictID, CategoryID) VALUES 
('John', 'Smith', 45, 1, 1),
('Emma', 'Jones', 30, 2, 2),
('Liam', 'Brown', 60, 3, 5),
('Olivia', 'Williams', 12, 4, 6),
('Noah', 'Taylor', 25, 5, 3),
('Isabella', 'Davies', 55, 6, 8),
('James', 'Evans', 40, 7, 7),
('Charlotte', 'Wilson', 20, 8, 4),
('Benjamin', 'Thomas', 65, 9, 5),
('Mia', 'Roberts', 10, 10, 6),
('Henry', 'Walker', 35, 11, 1),
('Amelia', 'White', 50, 12, 9),
('Lucas', 'Hall', 42, 13, 3),
('Sophia', 'Allen', 28, 14, 10),
('Ethan', 'Scott', 18, 15, 14);

-- Insert into PurposeType
INSERT INTO PurposeType (PurposeName) VALUES 
('Hip Operation'),
('General Checkup'),
('Cardiology Consultation'),
('Orthopedic Surgery'),
('Mental Health Support'),
('Routine Examination'),
('Vaccination'),
('Emergency Treatment'),
('Pediatric Care'),
('Dermatology'),
('Oncology Consultation'),
('Physiotherapy'),
('Dental Care'),
('Maternity Consultation'),
('ENT Checkup');

-- Insert into Admission
INSERT INTO Admission (AdmissionDate,WaitTimes, PatientID, PurposeID) VALUES 
('2024-08-14',15, 1, 1),
('2024-10-26',7, 2, 2),
('2024-06-13',30, 3, 3),
('2024-09-18',10, 4, 4),
('2024-09-24',5, 5, 5),
('2024-01-26',20, 6, 6),
('2024-05-04',25, 7, 7),
('2024-03-14',8, 8, 8),
('2024-12-02',45, 9, 9),
('2024-12-04',3, 10, 10),
('2024-12-03',12, 11, 11),
('2024-11-30',18, 12, 12),
('2024-11-29',22, 13, 13),
('2024-12-05',14, 14, 14),
('2024-12-05',6, 15, 15);


-- Basic Queries

--Show the number of unemployed patients
select count(P.FirstName) as Unemployed_Patients 
from Patient as P inner join EmploymentCategory as E 
on P.CategoryID=E.CategoryID 
where E.CategoryName="Unemployed";

-- Show the patients who got admitted after 2024-11-01 and before 2024-12-31
SELECT P.FirstName, P.LastName, A.AdmissionDate
FROM Admission A
INNER JOIN Patient P ON A.PatientID = P.PatientID
WHERE A.AdmissionDate BETWEEN '2024-11-01' AND '2024-12-31';


-- Medium Queries

-- Show the waiting list per county
SELECT Co.Name AS CountyName, COUNT(A.AdmissionID) AS WaitingListLength, AVG(A.WaitTimes) AS AverageWaitingTime
FROM Admission A
INNER JOIN Patient P ON A.PatientID = P.PatientID
INNER JOIN District D ON P.DistrictID = D.DistrictID
INNER JOIN County Co ON D.CountyID = Co.CountyID
GROUP BY Co.Name
ORDER BY WaitingListLength DESC;

-- Show the total number of patients per country
SELECT C.Name AS CountryName, COUNT(P.PatientID) AS PatientCount
FROM Patient AS P
INNER JOIN District AS D ON P.DistrictID = D.DistrictID
INNER JOIN County AS Co ON D.CountyID = Co.CountyID
INNER JOIN Country AS C ON Co.CountryID = C.CountryID
GROUP BY C.Name;

-- Show the total number of admissions and average waiting times for each purpose type.
SELECT PT.PurposeName AS PurposeType, COUNT(A.AdmissionID) AS TotalAdmissions, AVG(A.WaitTimes) AS AverageWaitTime
FROM Admission A
INNER JOIN PurposeType PT ON A.PurposeID = PT.PurposeID
GROUP BY PT.PurposeName
ORDER BY TotalAdmissions DESC;


-- Advanced Queries

-- Show the patient with the highest age
select FirstName, LastName, Age from Patient where Age = (select max(Age) from Patient);

-- Show the max wait times per county
SELECT Co.Name AS CountyName, MAX(A.WaitTimes) AS MaxWaitTime
FROM Admission A
INNER JOIN Patient P ON A.PatientID = P.PatientID
INNER JOIN District D ON P.DistrictID = D.DistrictID
INNER JOIN County Co ON D.CountyID = Co.CountyID
WHERE A.WaitTimes > (SELECT AVG(WaitTimes) FROM Admission)
GROUP BY Co.Name;

-- Show counties where the total waiting times for all admissions exceed the average total waiting times of all counties.
SELECT Co.Name AS CountyName, SUM(A.WaitTimes) AS TotalWaitTime
FROM Admission A
INNER JOIN Patient P ON A.PatientID = P.PatientID
INNER JOIN District D ON P.DistrictID = D.DistrictID
INNER JOIN County Co ON D.CountyID = Co.CountyID
GROUP BY Co.Name
HAVING SUM(A.WaitTimes) > (
SELECT AVG(TotalWaitTime) FROM (
SELECT Co.Name AS CountyName, SUM(A.WaitTimes) AS TotalWaitTime FROM Admission A
INNER JOIN Patient P ON A.PatientID = P.PatientID 
INNER JOIN District D ON P.DistrictID = D.DistrictID 
INNER JOIN County Co ON D.CountyID = Co.CountyID
GROUP BY Co.Name) AS CountyWaitTimes)
ORDER BY TotalWaitTime DESC;