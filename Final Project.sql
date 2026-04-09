-- This block creates the database and sets it to be used
CREATE DATABASE nation_is;
USE nation_is;

-- This block creates tables for contractors and locations which are used later
-- These need to be run before the projects and project_assignments tables

CREATE TABLE Contractor (
	Org_ID INT PRIMARY KEY AUTO_INCREMENT,
    Org_Name VARCHAR(100) NOT NULL,
    Org_Type ENUM ('Government', 'Contractor', 'Consultant'),
    Contact_Info VARCHAR(100) NOT NULL
    );

CREATE TABLE Locations (
	Location_ID INT PRIMARY KEY AUTO_INCREMENT,
    City VARCHAR(100),
    Province VARCHAR(100)
    );

-- This block creates the projects and project_assignment tables, projects
-- contains in-depth project information and connection to location data
-- project_assignment connects assignments with contractors for referencing

CREATE TABLE Projects (
	Project_ID INT PRIMARY KEY AUTO_INCREMENT,
    Project_Name VARCHAR(100) NOT NULL,
    Project_Type VARCHAR(100) NOT NULL,
    Start_Date DATE NOT NULL,
    End_Date DATE,
    Budget INT,
    Project_Status ENUM ('Planned', 'In-Progress', 'Completed') NOT NULL,
    Location_ID INT,
    FOREIGN KEY (Location_ID) REFERENCES Locations(Location_ID) ON DELETE CASCADE
    );
    
CREATE TABLE Project_Assignment (
	Assignment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Project_ID INT,
    Org_ID INT,
    FOREIGN KEY (Project_ID) REFERENCES Projects(Project_ID) ON DELETE CASCADE,
    FOREIGN KEY (Org_ID) REFERENCES Contractor(Org_ID) ON DELETE CASCADE
	);

-- To verify all tables have been made properly, run the following line
SHOW TABLES;

-- This large block populates the tables, data can be added into each table
-- following the structure described in each INSERT INTO command
-- Ensure the final block, project_assignment is run last
INSERT INTO Locations (City, Province) VALUES
('Iqaluit', 'Nunavut'),
('Vancouver', 'British Columbia'),
('Kingston', 'Ontario'),
('Toronto', 'Ontario'),
('Thunder Bay', 'Ontario'),
('Calgary', 'Alberta'),
('Winnipeg', 'Manitoba');

INSERT INTO Contractor (Org_Name, Org_Type, Contact_Info) VALUES
('CN Rail', 'Contractor', 'cnrail@cnrail.ca'),
('Infrastructure Canada', 'Government', 'infrastructure@canada.ca'),
('Calgary Transit', 'Government', 'calgarytransit@canada.ca'),
('Environment and Climate Change Canada', 'Government', 'climate@canada.ca'),
('Hydro-One', 'Contractor', 'hydroone@gmail.com'),
('Port Creations.co', 'Contractor', 'portcreations@portcreations.com'),
('BC Housing Group', 'Contractor', 'bchousing@bchousing.com'),
('Road Developers of Canada', 'Contractor', 'roaddevelopers@roaddev.ca'),
('Ontario Clean Water Agency', 'Government', 'cleanwater@canada.ca'),
('Ev Installers.co', 'Contractor', 'evinstall@evinstall.com');

INSERT INTO Projects (Project_Name, Project_Type, Start_Date, End_Date, Budget, Project_Status, Location_ID) VALUES
('Sample', 'Infrastructure', '2027-01-01', '2030-01-01', 500000, 'Planned', NULL),
('High Speed Rail Corridor', 'Rail', '2032-05-06', '2040-01-01', 107000000, 'Planned', 4),
('Northern Remote Community Road Access', 'Transportation', '2037-01-05', '2045-01-06', 13700000, 'Planned', 5),
('Urban Light Rail Expansion', 'Rail', '2045-05-06', '2050-01-01', 26000000, 'Planned', 6),
('Flood Protection Systems', 'Environmental', '2038-05-06', '2050-01-01', 728000000, 'Planned', 7), 
('Renewable Energy Grid Upgrade', 'Energy', '2028-03-11', '2037-01-02', 890000000, 'Planned', 4),
('Arctic Deep-Water Port', 'Infrastructure', '2023-05-09', '2027-04-02', 57000000, 'In-Progress', 1),
('Affordable Housing Development', 'Housing', '2024-01-28', '2028-07-21', 20000000, 'In-Progress', 2),
('Highway Twinning Project', 'Infrastructure', '2022-05-17', '2030-10-11', 330000000, 'In-Progress', NULL),
('Water Treatment Plant Upgrades', 'Environmental', '2023-02-25', '2027-05-09', 50000000, 'In-Progress', 3),
('EV Charging Infrastructure Network', 'Infrastructure', '2025-12-15', '2028-09-01', 120000000, 'In-Progress', 4);

INSERT INTO Project_Assignment (Project_ID, Org_ID) VALUES
(1, 5),
(2, 1),
(3, 2),
(4, 3),
(5, 4),
(6, 5),
(7, 6),
(8, 7),
(9, 8),
(10, 9),
(11, 10);

-- This block can be expanded upon and uses commands to check for data
-- which has certain conditions. By the nature of this database a join will
-- likely be necessary, for most of them, below are some examples

-- For certain queries, like deleting or updating data, safe updates will need to be disabled
-- setting it 0 means off, 1 means on, please make sure to re-enable it afterwards
SET sql_safe_updates = 0;
SET sql_safe_updates = 1;

-- You can check all data in a specific table with the queries in this block
SELECT * FROM Locations;
SELECT * FROM Contractor;
SELECT * FROM Projects;
SELECT * FROM Project_Assignment;

-- This query retrieves projects in Ontario
SELECT DISTINCT Projects.Project_Name, Locations.Province
FROM Locations
INNER JOIN Projects ON Locations.Location_ID = Projects.Location_ID
WHERE Province = 'Ontario';

-- This query shows all active projects
SELECT Project_Name, Project_Status
FROM Projects
WHERE Project_Status = 'In-Progress';

-- This query checks how many contracts are assigned to each contractor
SELECT DISTINCT Contractor.Org_Name, COUNT(Project_Assignment.Assignment_ID)
FROM Contractor
INNER JOIN Project_Assignment ON Contractor.Org_ID = Project_Assignment.Org_ID
GROUP BY Contractor.Org_Name;

-- This updates the status of any given project to complete, in this case project 1
-- Refer to the previous query on all data in projects to check which ID to update
-- and to make sure this works
UPDATE Projects
SET Project_Status = 'Completed'
WHERE Project_ID = 1;

-- This query calculates the total budget of all projects groups by province
SELECT Locations.Province, SUM(Projects.Budget)
FROM Locations
INNER JOIN Projects ON Projects.Location_ID = Locations.Location_ID
GROUP BY Locations.Province;

-- This will delete a certain item from list based on the condition
-- In this case project 1 was just an example and we don't want it clogging the database
DELETE FROM Projects
WHERE Project_Name = 'Sample';