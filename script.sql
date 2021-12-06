PRAGMA foreign_keys = ON;
--Drop all tables in our our database
DROP TABLE IF EXISTS Spectator;
DROP TABLE IF EXISTS Event;
DROP TABLE IF EXISTS Employer;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Steward;
DROP TABLE IF EXISTS Marshal;
DROP TABLE IF EXISTS Team;
DROP TABLE IF EXISTS Driver;
DROP TABLE IF EXISTS EventEmployers;
DROP TABLE IF EXISTS Task;
DROP TABLE IF EXISTS SpecDriverViewTracker;
DROP TABLE IF EXISTS StewardDriverUpdateTracker;
DROP TABLE IF EXISTS StewardDriverViewTracker;
DROP TABLE IF EXISTS SpecTeamViewTracker;
DROP TABLE IF EXISTS StewardTeamUpdateTracker;
DROP TABLE IF EXISTS StewardTeamViewTracker;
DROP TABLE IF EXISTS SpectatorEvents;


CREATE TABLE Spectator (
    spec_id INTEGER PRIMARY KEY,
    name VARCHAR(30)
);

CREATE TABLE Event (
    event_id INTEGER PRIMARY KEY,
    name VARCHAR(30),
    location VARCHAR(30),
    time DATETIME
); 

CREATE TABLE Employer (
    employer_id INTEGER PRIMARY KEY,
    name VARCHAR(30),
    role VARCHAR(30)
);

CREATE TABLE Employee(
    employee_id INTEGER PRIMARY KEY,
    employer_id INTEGER,
    name VARCHAR(30),
    role VARCHAR(30),
    FOREIGN KEY (employer_id) REFERENCES employer(employer_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Steward (
    employee_id INTEGER PRIMARY KEY,
    employer_id INTEGER,
    name VARCHAR(30),
    role VARCHAR(30),
    numberofpenalties INTEGER,
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (employer_id) REFERENCES employer(employer_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Marshal (
    employee_id INTEGER PRIMARY KEY,
    employer_id INTEGER,
    name VARCHAR(30),
    role VARCHAR(30),
    tracklocation VARCHAR(10),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (employer_id) REFERENCES employer(employer_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Team (
    employer_id INTEGER PRIMARY KEY,
    name VARCHAR(30),
    role VARCHAR(30),
    wins INTEGER,
    points FLOAT,
    overallstanding INTEGER,
    FOREIGN KEY (employer_id) REFERENCES employer(employer_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Driver(
    driver_id INTEGER PRIMARY KEY,
    team_id INTEGER,
    name VARCHAR(30),
    wins INTEGER,
    points FLOAT,
    overallstanding INTEGER,
    gpposition VARCHAR(3),
    fastestlap INTEGER,
    FOREIGN KEY (team_id) REFERENCES team(employer_id) ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE EventEmployers(
    event_id INTEGER,
    employer_id INTEGER,
    FOREIGN KEY (event_id) REFERENCES event(event_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (employer_id) REFERENCES Employer(employer_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK PRIMARY KEY (event_id, employer_id)
);

CREATE TABLE Task (
    task_id INTEGER,
    employer_id INTEGER,
    employee_id INTEGER,
    description VARCHAR(30),
    deadline DATETIME,
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (employer_id) REFERENCES employer(employer_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT PK PRIMARY KEY (employee_id, employer_id, task_id)
);

CREATE TABLE SpecDriverViewTracker (
    spec_id INTEGER,
    driver_id INTEGER,
    timestamp DATETIME,
    FOREIGN KEY (spec_id) REFERENCES Spectator(spec_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT PK PRIMARY KEY (spec_id, driver_id, timestamp)
);

CREATE TABLE SpecTeamViewTracker (
    spec_id INTEGER ,
    employer_id INTEGER,
    timestamp DATETIME,
    FOREIGN KEY (spec_id) REFERENCES Spectator(spec_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (employer_id) REFERENCES Team(employer_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT PK PRIMARY KEY (spec_id, employer_id, timestamp)
);

CREATE TABLE StewardDriverUpdateTracker (
    employee_id INTEGER,
    driver_id INTEGER,
    timestamp DATETIME,
    FOREIGN KEY (employee_id) REFERENCES Steward(employee_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT PK PRIMARY KEY (employee_id, driver_id, timestamp)
);

CREATE TABLE StewardDriverViewTracker (
    employee_id INTEGER,
    driver_id INTEGER,
    timestamp DATETIME,
    FOREIGN KEY (employee_id) REFERENCES Steward(employee_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT PK PRIMARY KEY (employee_id, driver_id, timestamp)
);

CREATE TABLE StewardTeamUpdateTracker (
    employee_id INTEGER,
    employer_id INTEGER,
    timestamp DATETIME,
    FOREIGN KEY (employee_id) REFERENCES Steward(employee_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (employer_id) REFERENCES Team(employer_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT PK PRIMARY KEY (employee_id, employer_id, timestamp)
);

CREATE TABLE StewardTeamViewTracker (
    employee_id INTEGER,
    employer_id INTEGER,
    timestamp DATETIME,
    FOREIGN KEY (employee_id) REFERENCES Steward(employee_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (employer_id) REFERENCES Team(employer_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT PK PRIMARY KEY (employee_id, employer_id, timestamp)
);

--createing table for spectator events
CREATE TABLE SpectatorEvents (
    spec_id INTEGER,
    event_id INTEGER,
    FOREIGN KEY (spec_id) REFERENCES Spectator(spec_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (event_id) REFERENCES Event(event_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK PRIMARY KEY (spec_id, event_id)
);

--INSERTING EMPLOYERS (includes teams)
INSERT INTO Employer(employer_id, name, role) VALUES (1, 'Alfa Romeo Racing Orlen', 'f1team');
INSERT INTO Employer(employer_id, name, role) VALUES (2, 'Scuderia AlphaTauri Honda ', 'f1team');
INSERT INTO Employer(employer_id, name, role) VALUES (3, 'Alpine F1 Team', 'f1team');
INSERT INTO Employer(employer_id, name, role) VALUES (4, 'Aston Martin Cognizant F1 Team', 'f1team');
INSERT INTO Employer(employer_id, name, role) VALUES (5, 'Scuderia Ferrari Mission Winnow', 'f1team');
INSERT INTO Employer(employer_id, name, role) VALUES (6, 'Uralkali Haas F1 Team', 'f1team');
INSERT INTO Employer(employer_id, name, role) VALUES (7, 'McLaren F1 Team', 'f1team');
INSERT INTO Employer(employer_id, name, role) VALUES (8, 'Mercedes-AMG Petronas F1 Team', 'f1team');
INSERT INTO Employer(employer_id, name, role) VALUES (9, 'Red Bull Racing Honda', 'f1team');
INSERT INTO Employer(employer_id, name, role) VALUES (10, 'Williams Racing', 'f1team');
INSERT INTO Employer(employer_id, name, role) VALUES (11, "Federation Internationale de l'Automobile", 'organizingbody');
INSERT INTO Employer(employer_id, name, role) VALUES (12, 'Circuit of the Americas LLC', 'trackside');
INSERT INTO Employer(employer_id, name, role) VALUES (13, 'COTA Concerts', 'concerts');
--adding 15 nonteam employer
INSERT INTO Employer(employer_id, name, role) VALUES (14, 'Grey Hound', 'transportation');
INSERT INTO Employer(employer_id, name, role) VALUES (15, 'Carls Jr', 'food');
INSERT INTO Employer(employer_id, name, role) VALUES (16, 'Dennys', 'food');
INSERT INTO Employer(employer_id, name, role) VALUES (17, 'Five Star Resturant', 'food');
INSERT INTO Employer(employer_id, name, role) VALUES (18, 'Chuck E Cheese', 'minigames');
INSERT INTO Employer(employer_id, name, role) VALUES (19, 'Merch Store', 'merchandise');
INSERT INTO Employer(employer_id, name, role) VALUES (20, 'Tidy', 'cleaning');
INSERT INTO Employer(employer_id, name, role) VALUES (21, 'G4S', 'security');
INSERT INTO Employer(employer_id, name, role) VALUES (22, 'Austin Police Department', 'lawenforcement');
INSERT INTO Employer(employer_id, name, role) VALUES (23, 'Austin EMT', 'medical');
INSERT INTO Employer(employer_id, name, role) VALUES (24, 'Accessibility LLC', 'accessibility');
INSERT INTO Employer(employer_id, name, role) VALUES (25, 'Austin Shuttle Service', 'transportation');
INSERT INTO Employer(employer_id, name, role) VALUES (26, 'Stadium Vendors Inc.', 'merchandise');
INSERT INTO Employer(employer_id, name, role) VALUES (27, 'Texstar Networking', 'networks');
INSERT INTO Employer(employer_id, name, role) VALUES (28, 'Texas Marketing Solutions', 'advertisement');





--DELETE
--FROM Driver;
--DELETE
--From Team;

--INSERTING TEAMS
INSERT INTO Team(employer_id, name, role, wins, points, overallstanding) VALUES (1, 'Alfa Romeo Racing Orlen', 'f1team', 0, 0, 0);
INSERT INTO Team(employer_id, name, role, wins, points, overallstanding) VALUES (2, 'Scuderia AlphaTauri Honda', 'f1team', 0, 0, 0);
INSERT INTO Team(employer_id, name, role, wins, points, overallstanding) VALUES (3, 'Alpine F1 Team', 'f1team', 0, 0, 0);
INSERT INTO Team(employer_id, name, role, wins, points, overallstanding) VALUES (4, 'Aston Martin Cognizant F1 Team', 'f1team', 0, 0, 0);
INSERT INTO Team(employer_id, name, role, wins, points, overallstanding) VALUES (5, 'Scuderia Ferrari Mission Winnow', 'f1team', 0, 0, 0);
INSERT INTO Team(employer_id, name, role, wins, points, overallstanding) VALUES (6, 'Uralkali Haas F1 Team', 'f1team', 0, 0, 0);
INSERT INTO Team(employer_id, name, role, wins, points, overallstanding) VALUES (7, 'McLaren F1 Team', 'f1team', 0, 0, 0);
INSERT INTO Team(employer_id, name, role, wins, points, overallstanding) VALUES (8, 'Mercedes-AMG Petronas F1 Team', 'f1team', 0, 0, 0);
INSERT INTO Team(employer_id, name, role, wins, points, overallstanding) VALUES (9, 'Red Bull Racing Honda', 'f1team', 0, 0, 0);
INSERT INTO Team(employer_id, name, role, wins, points, overallstanding) VALUES (10, 'Williams Racing', 'f1team', 0, 0, 0);

--INSERTING DRIVERS
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition, fastestlap) VALUES (1, 1,  'Kimi Raikkonen',        0, 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition, fastestlap) VALUES (2, 1,  'Antonio Giovinazzi',    0, 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition, fastestlap) VALUES (3, 2,  'Pierre Gasly',          0, 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition, fastestlap) VALUES (4, 2,  'Yuki Tsunoda',          0, 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition, fastestlap) VALUES (5, 3,  'Fernando Alonso',       0, 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition, fastestlap) VALUES (6, 3,  'Esteban Ocon',          0, 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition, fastestlap) VALUES (7, 4,  'Sebastian Vettel',      0, 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition, fastestlap) VALUES (8, 4,  'Lance Stroll',          0, 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition, fastestlap) VALUES (9, 5,  'Charles Leclerc',       0, 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition, fastestlap) VALUES (10, 5, 'Carlos Sainz Jr.',      0, 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition, fastestlap) VALUES (11, 6, 'Nikita Mazepin',        0, 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition, fastestlap) VALUES (12, 6, 'Mick Schumacher',       0, 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition, fastestlap) VALUES (13, 7, 'Daniel Ricciardo',      0, 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition, fastestlap) VALUES (14, 7, 'Lando Norris',          0, 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition, fastestlap) VALUES (15, 8, 'Lewis Hamilton',        0, 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition, fastestlap) VALUES (16, 8, 'Valtteri Bottas',       0, 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition, fastestlap) VALUES (17, 9, 'Sergio Perez',          0, 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition, fastestlap) VALUES (18, 9, 'Max Verstappen',        0, 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition, fastestlap) VALUES (19, 10,'Nicholas Latifi',       0, 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition, fastestlap) VALUES (20, 10,'George Russell',        0, 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition, fastestlap) VALUES (21, 1, 'Robert Kubica',         0, 0, 0, 0, 0);

--INSERTING EVENTS
INSERT INTO Event(event_id, name, location, time) VALUES (1, 'Formula 1 Free Practice 1', 'COTA Track', '2021-10-22 11:30:00');
INSERT INTO Event(event_id, name, location, time) VALUES (2, 'Formula 1 Free Practice 2', 'COTA Track', '2021-10-22 15:30:00');
INSERT INTO Event(event_id, name, location, time) VALUES (3, 'Formula 1 Free Practice 3', 'COTA Track', '2021-10-23 13:00:00');
INSERT INTO Event(event_id, name, location, time) VALUES (4, 'Formula 1 Qualifying', 'COTA Track', '2021-10-23 16:00:00');
INSERT INTO Event(event_id, name, location, time) VALUES (5, 'Formula 1 Grand Prix', 'COTA Track', '2021-10-24 14:00:00');
INSERT INTO Event(event_id, name, location, time) VALUES (6, 'Twenty One Pilots Concert', 'Germania Insurance Super Stage', '2021-10-22 19:30:00');
INSERT INTO Event(event_id, name, location, time) VALUES (7, 'Billy Joel', 'Germania Insurance Super Stage', '2021-10-23 19:30:00');
INSERT INTO Event(event_id, name, location, time) VALUES (8, 'Austin Polka Band', 'BIERGARTEN (T2)', '2021-10-23 12:00:00');
INSERT INTO Event(event_id, name, location, time) VALUES (9, 'Major League Eating Contest', 'ONEDERLAND', '2021-10-23 18:30:00');
INSERT INTO Event(event_id, name, location, time) VALUES (10, 'Daniel Ricciardo NASCAR DEMO', 'COTA Track', '2021-10-24 8:50:00');

INSERT INTO Event(event_id, name, location, time) VALUES (11, 'The Motts', 'Fan Zone', '2021-10-22 13:00:00');
INSERT INTO Event(event_id, name, location, time) VALUES (12, 'DJ AQ', 'LA CANTINA (T6)', '2021-10-22 13:00:00');
INSERT INTO Event(event_id, name, location, time) VALUES (13, 'Jess Daniel', 'LONESTAR LAND (T16)', '2021-10-22 14:00:00');
INSERT INTO Event(event_id, name, location, time) VALUES (14, 'DJ AQ', 'LA CANTINA (T6)', '2021-10-22 14:00:00');
INSERT INTO Event(event_id, name, location, time) VALUES (15, 'Shooks', 'Fan Zone', '2021-10-22 14:00:00');
INSERT INTO Event(event_id, name, location, time) VALUES (16, 'Croy & The Boys', 'LONESTAR LAND (T16)', '2021-10-22 17:05:00');
INSERT INTO Event(event_id, name, location, time) VALUES (17, 'Feliz', 'LA CANTINA (T6)', '2021-10-22 17:05:00');
INSERT INTO Event(event_id, name, location, time) VALUES (18, 'Lucha Libre', 'LA CANTINA (T6)', '2021-10-23 11:05:00');
INSERT INTO Event(event_id, name, location, time) VALUES (19, 'Zackery Taylor', 'LONESTAR LAND (T6)', '2021-10-23 12:05:00');
INSERT INTO Event(event_id, name, location, time) VALUES (20, 'Pat G', 'Fan Zone', '2021-10-23 12:05:00');

INSERT INTO Event(event_id, name, location, time) VALUES (21, 'El Tule', 'Fan Zone', '2021-10-23 12:05:00');
INSERT INTO Event(event_id, name, location, time) VALUES (22, 'DJ Chorizo Funk', 'RODEO DRIVEWAY (MGS)', '2021-10-23 13:00:00');
INSERT INTO Event(event_id, name, location, time) VALUES (23, 'Austin Polka Band', 'BIERGARTEN (T2)', '2021-10-23 14:00:00');
INSERT INTO Event(event_id, name, location, time) VALUES (24, 'Nina Diaz', 'Fan Zone', '2021-10-23 14:05:00');
INSERT INTO Event(event_id, name, location, time) VALUES (25, 'Rattlesnake Milk', 'LONESTAR LAND (T16)', '2021-10-23 14:05:00');
INSERT INTO Event(event_id, name, location, time) VALUES (26, 'DJ Chorizo Funk', 'RODEO DRIVEWAY (MGS)', '2021-10-23 14:05:00');
INSERT INTO Event(event_id, name, location, time) VALUES (27, 'Lucha Libre', 'LA CANTINA (T6)', '2021-10-23 14:05:00');
INSERT INTO Event(event_id, name, location, time) VALUES (28, 'Austin Polka Band', 'BIERGARTEN (T2)', '2021-10-23 15:00:00');
INSERT INTO Event(event_id, name, location, time) VALUES (29, 'The Districts', 'Fan Zone', '2021-10-23 15:05:00');
INSERT INTO Event(event_id, name, location, time) VALUES (30, 'Mayeux & Broussard', 'LONESTAR LAND (T16)', '2021-10-23 15:05:00');

INSERT INTO Event(event_id, name, location, time) VALUES (31, 'Serumn', 'LA CANTINA (T6)', '2021-10-23 15:05:00');
INSERT INTO Event(event_id, name, location, time) VALUES (32, 'Neil Diamond (Tribute)', 'RODEO DRIVEWAY (MGS)', '2021-10-23 15:05:00');
INSERT INTO Event(event_id, name, location, time) VALUES (33, 'Magnifico', 'Fan Zone', '2021-10-23 17:05:00');
INSERT INTO Event(event_id, name, location, time) VALUES (34, 'Garret T. Capps', 'LA CANTINA (T6)', '2021-10-23 17:05:00');
INSERT INTO Event(event_id, name, location, time) VALUES (35, 'Bidi Bidi Banda', 'LA CANTINA (T6)', '2021-10-23 17:05:00');
INSERT INTO Event(event_id, name, location, time) VALUES (36, 'Spamorama', 'ONEDERLAND', '2021-10-23 17:35:00');
INSERT INTO Event(event_id, name, location, time) VALUES (37, 'Major League Eating Contest', 'ONEDERLAND', '2021-10-23 18:05:00');
INSERT INTO Event(event_id, name, location, time) VALUES (38, 'Money Chicha', 'LA CANTINA (T6)', '2021-10-24 11:30:00');
INSERT INTO Event(event_id, name, location, time) VALUES (39, 'Austin Polka Band', 'BIERGARTEN (T2)', '2021-10-24 13:30:00');
INSERT INTO Event(event_id, name, location, time) VALUES (40, 'Mobley', 'Fan Zone', '2021-10-24 13:00:00');

INSERT INTO Event(event_id, name, location, time) VALUES (41, 'Rob Baird', 'LONESTAR LAND (T16)', '2021-10-24 13:00:00');
INSERT INTO Event(event_id, name, location, time) VALUES (42, 'Elvis (Tribute)', 'RODEO DRIVEWAY (MGS)', '2021-10-24 13:00:00');
INSERT INTO Event(event_id, name, location, time) VALUES (43, 'Joshua Ray Walker', 'LONESTAR LAND (T16)', '2021-10-24 16:05:00');
INSERT INTO Event(event_id, name, location, time) VALUES (44, 'Metalachi', 'LA CANTINA (T6)', '2021-10-24 16:05:00');
INSERT INTO Event(event_id, name, location, time) VALUES (45, 'Neil Diamond (Tribute)', 'BIERGARTEN (T2)', '2021-10-24 16:05:00');
INSERT INTO Event(event_id, name, location, time) VALUES (46, 'Diesel', 'ONEDERLAND', '2021-10-24 17:30:00');
INSERT INTO Event(event_id, name, location, time) VALUES (47, 'Kool & The Gang', 'GERMANIA INSURANCE AMPHITHEATER', '2021-10-24 16:30:00');

-- INSERT INTO Employer(employer_id, name, role) VALUES (14, 'Grey Hound', 'transportation');
-- INSERT INTO Employer(employer_id, name, role) VALUES (15, 'Carls Jr', 'food');
-- INSERT INTO Employer(employer_id, name, role) VALUES (16, 'Dennys', 'food');
-- INSERT INTO Employer(employer_id, name, role) VALUES (17, 'Five Star Resturant', 'food');
-- INSERT INTO Employer(employer_id, name, role) VALUES (18, 'Chuck E Cheese', 'minigames');
-- INSERT INTO Employer(employer_id, name, role) VALUES (19, 'Merch Store', 'merchandise');
-- INSERT INTO Employer(employer_id, name, role) VALUES (20, 'Tidy', 'cleaning');
-- INSERT INTO Employer(employer_id, name, role) VALUES (21, 'G4S', 'security');
-- INSERT INTO Employer(employer_id, name, role) VALUES (22, 'Austin Police Department', 'lawenforcement');
-- INSERT INTO Employer(employer_id, name, role) VALUES (23, 'Austin EMT', 'medical');
-- INSERT INTO Employer(employer_id, name, role) VALUES (24, 'Accessibility LLC', 'accessibility');
-- INSERT INTO Employer(employer_id, name, role) VALUES (25, 'Austin Shuttle Service', 'transportation');
-- INSERT INTO Employer(employer_id, name, role) VALUES (26, 'Stadium Vendors Inc.', 'merchandise');
-- INSERT INTO Employer(employer_id, name, role) VALUES (27, 'Texstar Networking', 'networks');
-- INSERT INTO Employer(employer_id, name, role) VALUES (28, 'Texas Marketing Solutions', 'advertisement');




--INSERTING EMPLOYEES (for now just the principals)
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (1, 1, "Frederic Vasseur", "Principal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (2, 2, "Franz Tost", "Principal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (3, 3, "Laurent Rossi", "Principal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (4, 4, "Otmar Szafnauer", "Principal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (5, 5, "Mattia Binotto", "Principal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (6, 6, "Guenther Steiner", "Principal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (7, 7, "Andreas Seidl", "Principal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (8, 8, "Toto Wolff", "Principal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (9, 9, "Christian Horner", "Principal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (10, 10,"Jost Capito", "Principal");

-- adding 100 tuples into employee



--INSERTING MARSHALS into MARSHALS AND EMPLOYEES
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (11, 12, "Micheal Carter","Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (12, 12, "Santiago Holloway","Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (13, 12, "Marcos Guzman", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (14, 12, "Nora Christensen ", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (15, 12, "Misty Silva","Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (16, 12, "Jessica Alonso", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (17, 12, "Ryder Tatham", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (18, 12, "Phoebe Ayers", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (19, 12, "Emily Hathway","Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (20, 12, "Sandra Saunders", "Marshal");
-- adding 100 tuples into employee

INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (31, 12, "Conrad Edwards", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (32, 12, "Emmanuel Hess", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (33, 12, "Jaylynn Singh", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (34, 12, "Benjamin Benton", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (35, 12, "Melvin Marks", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (36, 12, "Greyson Savage", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (37, 12, "Jaliyah Howard", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (38, 12, "Dixie Cherry", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (39, 12, "Giovanni Riddle","Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (40, 12, "Silas Griffin", "Marshal");

INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (41, 12, "Neveah Lawrence", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (42, 12, "Donavan Silva", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (43, 12, "Maddox Ellis", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (44, 12, "Fabian Hogan", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (45, 12, "Roderick Arnold", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (46, 12, "Aiden Zhang", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (47, 12, "Zachariah Kennedy", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (48, 12, "Agustin Graves", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (49, 12, "Stacy Middleton","Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (50, 12, "Alani Macdonald", "Marshal");


INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (51, 12, "Denise Wade", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (52, 12, "Stephany Huerta", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (53, 12, "Ashly Reid", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (54, 12, "Jovan Walls", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (55, 12, "Briley Carroll", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (56, 12, "Sidney Cohen", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (57, 12, "Zain Pennington", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (58, 12, "Elaine Park", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (59, 12, "Denise Griffin","Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (60, 12, "Brycen Hood", "Marshal");

INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (61, 12, "Daniella Hamilton", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (62, 12, "Addisyn Martinez", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (63, 12, "Natasha Wheeler", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (64, 12, "Marvin Oneal", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (65, 12, "Ella Zamora", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (66, 12, "Damari Beard", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (67, 12, "Chad Wu", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (68, 12, "Diamond Peterson", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (69, 12, "Jacquelyn Houston","Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (70, 12, "Moriah Hinton", "Marshal");

INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (71, 12, "Elsa Archer", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (72, 12, "Janiya MoonAd", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (73, 12, "Ada Wise", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (74, 12, "Marina Mclean", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (75, 12, "Roy Sanders", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (76, 12, "Fatima Morrison", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (77, 12, "William Wolf", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (78, 12, "Amari Ritter", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (79, 12, "Darwin Schmidt","Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (80, 12, "Aidan Ramsey", "Marshal");

INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (81, 12, "Jaiden Conley", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (82, 12, "Tessa Perkins", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (83, 12, "Rogelio Sampson", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (84, 12, "Case Atkins", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (85, 12, "Alberto Gregory", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (86, 12, "Elian Farley", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (87, 12, "Emmett Hinton", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (88, 12, "Chaim Mcbride", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (89, 12, "Roy Monroe","Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (90, 12, "Cash Hendricks", "Marshal");

INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (91, 12, "Talan Gutierrez", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (92, 12, "Fisher Sharp", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (93, 12, "Raphael Acosta", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (94, 12, "Jazlene Estrada", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (95, 12, "Bronson Mack", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (96, 12, "Sherlyn Meyer", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (97, 12, "Emma Erickson", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (98, 12, "Jared Doyle", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (99, 12, "Marlie Strong","Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (100, 12, "Jazmin Horn", "Marshal");

INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (101, 12, "Kash Parson", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (102, 12, "Megan Rubio", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (103, 12, "Maliyah Hinton", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (104, 12, "Amaris Gardner", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (105, 12, "Holly Donaldson", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (106, 12, "Charlie Davenport", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (107, 12, "Amira Rangel", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (108, 12, "Edward Rivera", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (109, 12, "Roman Pennington","Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (110, 12, "Rubi Waters", "Marshal");

INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (111, 12, "Parker Johns", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (112, 12, "Dakota Bowen", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (113, 12, "Jayvon Arroyo", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (114, 12, "Chloe Reese", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (115, 12, "Armani Golden", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (116, 12, "Angeline Cisneros", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (117, 12, "Dean Mathis", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (118, 12, "Gabriel Robinson", "Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (119, 12, "Brennen Whitehead","Marshal");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (120, 12, "Juliet Hester", "Marshal");


--end employee


INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (11, 12, "Micheal Carter", "Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (12, 12, "Santiago Holloway", "Marshal", "T10");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (13, 12, "Marcos Guzman", "Marshal", "T3");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (14, 12, "Nora Christensen", "Marshal", "T1");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (15, 12, "Misty Silva", "Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (16, 12, "Jessica Alonso", "Marshal", "T5");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (17, 12, "Ryder Tatham", "Marshal", "T2");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (18, 12, "Phoebe Ayers", "Marshal", "T7");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (19, 12, "Emily Hathway","Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (20, 12, "Sandra Saunders", "Marshal", "T11");

-- adding 100 tuples into marshal

INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (31, 12, "Conrad Edwards", "Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (32, 12, "Emmanuel Hess", "Marshal", "T10");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (33, 12, "Jaylynn Singh", "Marshal", "T3");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (34, 12, "Benjamin Benton", "Marshal", "T1");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (35, 12, "Melvin Marks", "Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (36, 12, "Greyson Savage", "Marshal", "T5");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (37, 12, "Jaliyah Howard", "Marshal", "T2");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (38, 12, "Dixie Cherry", "Marshal", "T7");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (39, 12, "Giovanni Riddle","Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (40, 12, "Silas Griffin", "Marshal", "T11");

INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (41, 12, "Neveah Lawrence", "Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (42, 12, "Donavan Silva", "Marshal", "T10");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (43, 12, "Maddox Ellis", "Marshal", "T3");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (44, 12, "Fabian Hogan", "Marshal", "T1");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (45, 12, "Roderick Arnold", "Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (46, 12, "Aiden Zhang", "Marshal", "T5");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (47, 12, "Zachariah Kennedy", "Marshal", "T2");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (48, 12, "Agustin Graves", "Marshal", "T7");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (49, 12, "Stacy Middleton","Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (50, 12, "Alani Macdonald", "Marshal", "T11");


INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (51, 12, "Denise Wade", "Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (52, 12, "Stephany Huerta", "Marshal", "T10");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (53, 12, "Ashly Reid", "Marshal", "T3");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (54, 12, "Jovan Walls", "Marshal", "T1");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (55, 12, "Briley Carroll", "Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (56, 12, "Sidney Cohen", "Marshal", "T5");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (57, 12, "Zain Pennington", "Marshal", "T2");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (58, 12, "Elaine Park", "Marshal", "T7");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (59, 12, "Denise Griffin","Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (60, 12, "Brycen Hood", "Marshal", "T11");

INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (61, 12, "Daniella Hamilton", "Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (62, 12, "Addisyn Martinez", "Marshal", "T10");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (63, 12, "Natasha Wheeler", "Marshal", "T3");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (64, 12, "Marvin Oneal", "Marshal", "T1");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (65, 12, "Ella Zamora", "Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (66, 12, "Damari Beard", "Marshal", "T5");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (67, 12, "Chad Wu", "Marshal", "T2");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (68, 12, "Diamond Peterson", "Marshal", "T7");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (69, 12, "Jacquelyn Houston","Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (70, 12, "Moriah Hinton", "Marshal", "T11");

INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (71, 12, "Elsa Archer", "Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (72, 12, "Janiya MoonAd", "Marshal", "T10");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (73, 12, "Ada Wise", "Marshal", "T3");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (74, 12, "Marina Mclean", "Marshal", "T1");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (75, 12, "Roy Sanders", "Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (76, 12, "Fatima Morrison", "Marshal", "T5");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (77, 12, "William Wolf", "Marshal", "T2");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (78, 12, "Amari Ritter", "Marshal", "T7");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (79, 12, "Darwin Schmidt","Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (80, 12, "Aidan Ramsey", "Marshal", "T11");

INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (81, 12, "Jaiden Conley", "Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (82, 12, "Tessa Perkins", "Marshal", "T10");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (83, 12, "Rogelio Sampson", "Marshal", "T3");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (84, 12, "Case Atkins", "Marshal", "T1");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (85, 12, "Alberto Gregory", "Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (86, 12, "Elian Farley", "Marshal", "T5");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (87, 12, "Emmett Hinton", "Marshal", "T2");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (88, 12, "Chaim Mcbride", "Marshal", "T7");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (89, 12, "Roy Monroe","Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (90, 12, "Cash Hendricks", "Marshal", "T11");

INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (91, 12, "Talan Gutierrez", "Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (92, 12, "Fisher Sharp", "Marshal", "T10");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (93, 12, "Raphael Acosta", "Marshal", "T3");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (94, 12, "Jazlene Estrada", "Marshal", "T1");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (95, 12, "Bronson Mack", "Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (96, 12, "Sherlyn Meyer", "Marshal", "T5");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (97, 12, "Emma Erickson", "Marshal", "T2");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (98, 12, "Jared Doyle", "Marshal", "T7");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (99, 12, "Marlie Strong","Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (100, 12, "Jazmin Horn", "Marshal", "T11");

INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (101, 12, "Kash Parson", "Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (102, 12, "Megan Rubio", "Marshal", "T10");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (103, 12, "Maliyah Hinton", "Marshal", "T3");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (104, 12, "Amaris Gardner", "Marshal", "T1");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (105, 12, "Holly Donaldson", "Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (106, 12, "Charlie Davenport", "Marshal", "T5");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (107, 12, "Amira Rangel", "Marshal", "T2");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (108, 12, "Edward Rivera", "Marshal", "T7");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (109, 12, "Roman Pennington","Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (110, 12, "Rubi Waters", "Marshal", "T11");

INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (111, 12, "Parker Johns", "Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (112, 12, "Dakota Bowen", "Marshal", "T10");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (113, 12, "Jayvon Arroyo", "Marshal", "T3");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (114, 12, "Chloe Reese", "Marshal", "T1");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (115, 12, "Armani Golden", "Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (116, 12, "Angeline Cisneros", "Marshal", "T5");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (117, 12, "Dean Mathis", "Marshal", "T2");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (118, 12, "Gabriel Robinson", "Marshal", "T7");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (119, 12, "Brennen Whitehead","Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (120, 12, "Juliet Hester", "Marshal", "T11");

--INSERTING STEWARDS into STEWARDS and EMPLOYEES
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (21, 11, "Norton Pender","Steward");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (22, 11, "Emily Jeanes","Steward");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (23, 11, "Josue Harden","Steward");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (24, 11, "Emiliano Romero","Steward");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (25, 11, "Katelijne Essie","Steward");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (26, 11, "Maddox Markku","Steward");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (27, 11, "Kobe Bryant","Steward");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (28, 11, "Stephen Curry","Steward");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (29, 11, "Micheal Jordan","Steward");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (30, 11, "Lebron James","Steward");

INSERT INTO Steward(employee_id, employer_id, name, role, numberofpenalties) VALUES (21, 11, "Norton Pender","Steward", 0);
INSERT INTO Steward(employee_id, employer_id, name, role, numberofpenalties) VALUES (22, 11, "Emily Jeanes","Steward", 0);
INSERT INTO Steward(employee_id, employer_id, name, role, numberofpenalties) VALUES (23, 11, "Josue Harden","Steward", 0);
INSERT INTO Steward(employee_id, employer_id, name, role, numberofpenalties) VALUES (24, 11, "Emiliano Romero","Steward", 0);
INSERT INTO Steward(employee_id, employer_id, name, role, numberofpenalties) VALUES (25, 11, "Katelijne Essie","Steward", 0);
INSERT INTO Steward(employee_id, employer_id, name, role, numberofpenalties) VALUES (26, 11, "Maddox Markku","Steward", 0);
INSERT INTO Steward(employee_id, employer_id, name, role, numberofpenalties) VALUES (27, 11, "Kobe Bryant","Steward", 0);
INSERT INTO Steward(employee_id, employer_id, name, role, numberofpenalties) VALUES (28, 11, "Stephen Curry","Steward", 0);
INSERT INTO Steward(employee_id, employer_id, name, role, numberofpenalties) VALUES (29, 11, "Micheal Jordan","Steward", 0);
INSERT INTO Steward(employee_id, employer_id, name, role, numberofpenalties) VALUES (30, 11, "Lebron James","Steward", 0);


--INSERTING SPECTATORS into SPECTATORS
INSERT INTO Spectator(spec_id, name) VALUES (1, "Cindy Marini");
INSERT INTO Spectator(spec_id, name) VALUES (2, "Eduard Tollemache");
INSERT INTO Spectator(spec_id, name) VALUES (3, "Niklas Bagley");
INSERT INTO Spectator(spec_id, name) VALUES (4, "Lara Falk");
INSERT INTO Spectator(spec_id, name) VALUES (5, "Henrik Bader");
INSERT INTO Spectator(spec_id, name) VALUES (6, "Ariel Dias");
INSERT INTO Spectator(spec_id, name) VALUES (7, "Romana Summers");
INSERT INTO Spectator(spec_id, name) VALUES (8, "Patrick Star");
INSERT INTO Spectator(spec_id, name) VALUES (9, "Spongebob Squarepants");
INSERT INTO Spectator(spec_id, name) VALUES (10, "Zuko Ozai");
INSERT INTO Spectator(spec_id, name) VALUES (11, "Shubham Anna");

--INSERTING TRACKER
INSERT INTO SpecDriverViewTracker(spec_id, driver_id, timestamp) VALUES (1, 1, '2021-10-22 11:30:00');
INSERT INTO SpecDriverViewTracker(spec_id, driver_id, timestamp) VALUES (2, 2, '2021-10-22 11:30:00');
INSERT INTO SpecDriverViewTracker(spec_id, driver_id, timestamp) VALUES (3, 3, '2021-10-22 11:30:00');
INSERT INTO SpecDriverViewTracker(spec_id, driver_id, timestamp) VALUES (4, 4, '2021-10-22 11:30:00');
INSERT INTO SpecDriverViewTracker(spec_id, driver_id, timestamp) VALUES (5, 5, '2021-10-22 11:30:00');
INSERT INTO SpecDriverViewTracker(spec_id, driver_id, timestamp) VALUES (6, 6, '2021-10-22 11:30:00');
INSERT INTO SpecDriverViewTracker(spec_id, driver_id, timestamp) VALUES (7, 7, '2021-10-22 11:30:00');
INSERT INTO SpecDriverViewTracker(spec_id, driver_id, timestamp) VALUES (8, 8, '2021-10-22 11:30:00');
INSERT INTO SpecDriverViewTracker(spec_id, driver_id, timestamp) VALUES (9, 9, '2021-10-22 11:30:00');
INSERT INTO SpecDriverViewTracker(spec_id, driver_id, timestamp) VALUES (10, 10, '2021-10-22 11:30:00');

INSERT INTO SpecTeamViewTracker(spec_id, employer_id, timestamp) VALUES (1, 1, '2021-10-22 12:30:00');
INSERT INTO SpecTeamViewTracker(spec_id, employer_id, timestamp) VALUES (2, 2, '2021-10-22 12:30:00');
INSERT INTO SpecTeamViewTracker(spec_id, employer_id, timestamp) VALUES (3, 3, '2021-10-22 12:30:00');
INSERT INTO SpecTeamViewTracker(spec_id, employer_id, timestamp) VALUES (4, 4, '2021-10-22 12:30:00');
INSERT INTO SpecTeamViewTracker(spec_id, employer_id, timestamp) VALUES (5, 5, '2021-10-22 12:30:00');
INSERT INTO SpecTeamViewTracker(spec_id, employer_id, timestamp) VALUES (6, 6, '2021-10-22 12:30:00');
INSERT INTO SpecTeamViewTracker(spec_id, employer_id, timestamp) VALUES (7, 7, '2021-10-22 12:30:00');
INSERT INTO SpecTeamViewTracker(spec_id, employer_id, timestamp) VALUES (8, 8, '2021-10-22 12:30:00');
INSERT INTO SpecTeamViewTracker(spec_id, employer_id, timestamp) VALUES (9, 9, '2021-10-22 12:30:00');
INSERT INTO SpecTeamViewTracker(spec_id, employer_id, timestamp) VALUES (10, 10, '2021-10-22 12:30:00');


INSERT INTO StewardDriverUpdateTracker(employee_id, driver_id, timestamp) VALUES (21,1,'2021-10-22 11:30:00');
INSERT INTO StewardDriverUpdateTracker(employee_id, driver_id, timestamp) VALUES (22,2,'2021-10-22 11:30:00');
INSERT INTO StewardDriverUpdateTracker(employee_id, driver_id, timestamp) VALUES (23,3,'2021-10-22 11:30:00');
INSERT INTO StewardDriverUpdateTracker(employee_id, driver_id, timestamp) VALUES (24,4,'2021-10-22 11:30:00');
INSERT INTO StewardDriverUpdateTracker(employee_id, driver_id, timestamp) VALUES (25,5,'2021-10-22 11:30:00');
INSERT INTO StewardDriverUpdateTracker(employee_id, driver_id, timestamp) VALUES (26,6,'2021-10-22 11:30:00');
INSERT INTO StewardDriverUpdateTracker(employee_id, driver_id, timestamp) VALUES (27,7,'2021-10-22 11:30:00');
INSERT INTO StewardDriverUpdateTracker(employee_id, driver_id, timestamp) VALUES (28,8,'2021-10-22 11:30:00');
INSERT INTO StewardDriverUpdateTracker(employee_id, driver_id, timestamp) VALUES (29,9,'2021-10-22 11:30:00');
INSERT INTO StewardDriverUpdateTracker(employee_id, driver_id, timestamp) VALUES (30,10,'2021-10-22 11:30:00');

INSERT INTO StewardTeamUpdateTracker(employee_id, employer_id, timestamp) VALUES (21,1,'2021-10-22 11:30:00');
INSERT INTO StewardTeamUpdateTracker(employee_id, employer_id, timestamp) VALUES (22,2,'2021-10-22 11:30:00');
INSERT INTO StewardTeamUpdateTracker(employee_id, employer_id, timestamp) VALUES (23,3,'2021-10-22 11:30:00');
INSERT INTO StewardTeamUpdateTracker(employee_id, employer_id, timestamp) VALUES (24,4,'2021-10-22 11:30:00');
INSERT INTO StewardTeamUpdateTracker(employee_id, employer_id, timestamp) VALUES (25,5,'2021-10-22 11:30:00');
INSERT INTO StewardTeamUpdateTracker(employee_id, employer_id, timestamp) VALUES (26,1,'2021-10-22 11:30:00');
INSERT INTO StewardTeamUpdateTracker(employee_id, employer_id, timestamp) VALUES (27,1,'2021-10-22 11:30:00');
INSERT INTO StewardTeamUpdateTracker(employee_id, employer_id, timestamp) VALUES (28,1,'2021-10-22 11:30:00');
INSERT INTO StewardTeamUpdateTracker(employee_id, employer_id, timestamp) VALUES (29,1,'2021-10-22 11:30:00');
INSERT INTO StewardTeamUpdateTracker(employee_id, employer_id, timestamp) VALUES (30,1,'2021-10-22 11:30:00');

INSERT INTO StewardDriverViewTracker(employee_id, driver_id, timestamp) VALUES (21,1,'2021-10-22 11:29:00');
INSERT INTO StewardDriverViewTracker(employee_id, driver_id, timestamp) VALUES (22,2,'2021-10-22 11:29:00');
INSERT INTO StewardDriverViewTracker(employee_id, driver_id, timestamp) VALUES (23,3,'2021-10-22 11:29:00');
INSERT INTO StewardDriverViewTracker(employee_id, driver_id, timestamp) VALUES (24,4,'2021-10-22 11:29:00');
INSERT INTO StewardDriverViewTracker(employee_id, driver_id, timestamp) VALUES (25,5,'2021-10-22 11:29:00');
INSERT INTO StewardDriverViewTracker(employee_id, driver_id, timestamp) VALUES (26,6,'2021-10-22 11:29:00');
INSERT INTO StewardDriverViewTracker(employee_id, driver_id, timestamp) VALUES (27,7,'2021-10-22 11:29:00');
INSERT INTO StewardDriverViewTracker(employee_id, driver_id, timestamp) VALUES (28,8,'2021-10-22 11:29:00');
INSERT INTO StewardDriverViewTracker(employee_id, driver_id, timestamp) VALUES (29,9,'2021-10-22 11:29:00');
INSERT INTO StewardDriverViewTracker(employee_id, driver_id, timestamp) VALUES (30,10,'2021-10-22 11:29:00');

INSERT INTO StewardTeamViewTracker(employee_id, employer_id, timestamp) VALUES (21,1,'2021-10-22 11:29:00');
INSERT INTO StewardTeamViewTracker(employee_id, employer_id, timestamp) VALUES (22,2,'2021-10-22 11:29:00');
INSERT INTO StewardTeamViewTracker(employee_id, employer_id, timestamp) VALUES (23,3,'2021-10-22 11:29:00');
INSERT INTO StewardTeamViewTracker(employee_id, employer_id, timestamp) VALUES (24,4,'2021-10-22 11:29:00');
INSERT INTO StewardTeamViewTracker(employee_id, employer_id, timestamp) VALUES (25,5,'2021-10-22 11:29:00');
INSERT INTO StewardTeamViewTracker(employee_id, employer_id, timestamp) VALUES (26,1,'2021-10-22 11:29:00');
INSERT INTO StewardTeamViewTracker(employee_id, employer_id, timestamp) VALUES (27,1,'2021-10-22 11:29:00');
INSERT INTO StewardTeamViewTracker(employee_id, employer_id, timestamp) VALUES (28,1,'2021-10-22 11:29:00');
INSERT INTO StewardTeamViewTracker(employee_id, employer_id, timestamp) VALUES (29,1,'2021-10-22 11:29:00');
INSERT INTO StewardTeamViewTracker(employee_id, employer_id, timestamp) VALUES (30,1,'2021-10-22 11:29:00');


--20 queries


--#1 UPDATE Driver Standings

UPDATE Driver
SET wins = 8, points = 287.5, overallstanding = 1, gpposition = 1, fastestlap = 0
WHERE name = 'Max Verstappen';

UPDATE Driver
SET wins = 5, points = 275.5, overallstanding = 2, gpposition = 2, fastestlap = 1
WHERE name = 'Lewis Hamilton';

UPDATE Driver
SET wins = 1, points = 185, overallstanding = 3, gpposition = 6, fastestlap = 0
WHERE name = 'Valtteri Bottas';

UPDATE Driver
SET wins = 1, points = 150, overallstanding = 4, gpposition = 3, fastestlap = 0
WHERE name = 'Sergio Perez';

UPDATE Driver
SET wins = 0, points = 149, overallstanding = 5, gpposition = 8, fastestlap = 0
WHERE name = 'Lando Norris';

UPDATE Driver
SET wins = 0, points = 128, overallstanding = 6, gpposition = 4, fastestlap = 0
WHERE name = 'Charles Leclerc';

UPDATE Driver
SET wins = 1, points = 122.5, overallstanding = 7, gpposition = 7, fastestlap = 0
WHERE name = 'Carlos Sainz Jr.';

UPDATE Driver
SET wins = 1, points = 105, overallstanding = 8, gpposition = 5, fastestlap = 0
WHERE name = 'Daniel Ricciardo';

UPDATE Driver
SET wins = 1, points = 74, overallstanding = 9, gpposition = 'DNF', fastestlap = 0
WHERE name = 'Pierre Gasly';

UPDATE Driver
SET wins = 0, points = 58, overallstanding = 10, gpposition = 'DNF', fastestlap = 0
WHERE name = 'Fernando Alonso';

UPDATE Driver
SET wins = 1, points = 46, overallstanding = 11, gpposition = 'DNF', fastestlap = 0
WHERE name = 'Esteban Ocon';

UPDATE Driver
SET wins = 0, points = 36, overallstanding = 12, gpposition = 10, fastestlap = 0
WHERE name = 'Sebastian Vettel';

UPDATE Driver
SET wins = 0, points = 26, overallstanding = 13, gpposition = 12, fastestlap = 0
WHERE name = 'Lance Stroll';

UPDATE Driver
SET wins = 0, points = 20, overallstanding = 14, gpposition = 9, fastestlap = 0
WHERE name = 'Yuki Tsunoda';

UPDATE Driver
SET wins = 0, points = 16, overallstanding = 15, gpposition = 14, fastestlap = 0
WHERE name = 'George Russell';

UPDATE Driver
SET wins = 0, points = 7, overallstanding = 16, gpposition = 15, fastestlap = 0
WHERE name = 'Nicholas Latifi';

UPDATE Driver
SET wins = 0, points = 6, overallstanding = 17, gpposition = 13, fastestlap = 0
WHERE name = 'Kimi Raikkonen';

UPDATE Driver
SET wins = 0, points = 1, overallstanding = 18, gpposition = 11, fastestlap = 0
WHERE name = 'Antonio Giovinazzi';

UPDATE Driver
SET wins = 0, points = 0, overallstanding = 19, gpposition = 16, fastestlap = 0
WHERE name = 'Mick Schumacher';

UPDATE Driver
SET wins = 0, points = 0, overallstanding = 20, gpposition = 'DNS', fastestlap = 0
WHERE name = 'Robert Kubica';  

UPDATE Driver
SET wins = 0, points = 0, overallstanding = 21, gpposition = 17, fastestlap = 0
WHERE name = 'Nikita Mazepin';  


--#2 WDC standings
SELECT driver_id, name, points
FROM Driver
ORDER BY points DESC;

--#3 Update teams
UPDATE Team
SET wins = 6, points = 460.5, overallstanding = 1
WHERE name = 'Mercedes-AMG Petronas F1 Team';

UPDATE Team
SET wins = 9, points = 437.5, overallstanding = 2
WHERE name = 'Red Bull Racing Honda';

UPDATE Team
SET wins = 1, points = 254, overallstanding = 3
WHERE name = 'McLaren F1 Team';

UPDATE Team
SET wins = 0, points = 250.5, overallstanding = 4
WHERE name = 'Scuderia Ferrari Mission Winnow';

UPDATE Team
SET wins = 1, points = 104, overallstanding = 5
WHERE name = 'Alpine F1 Team';

UPDATE Team
SET wins = 0, points = 94, overallstanding = 6
WHERE name = 'Scuderia AlphaTauri Honda';

UPDATE Team
SET wins = 0, points = 62, overallstanding = 7
WHERE name = 'Aston Martin Cognizant F1 Team';

UPDATE Team
SET wins = 0, points = 23, overallstanding = 8
WHERE name = 'Williams Racing';

UPDATE Team
SET wins = 0, points = 7, overallstanding = 9
WHERE name = 'Alfa Romeo Racing Orlen';

UPDATE Team
SET wins = 0, points = 0, overallstanding = 10
WHERE name = 'Uralkali Haas F1 Team';

--#4 WCC Standings
SELECT employer_id, name, points
FROM Team
ORDER BY points DESC;

--#5 Events before the race
SELECT E1.name, E1.location, E1.time
FROM Event E1, Event E2
WHERE E2.name = 'Formula 1 Grand Prix' AND
    E1.time < E2.time;

--#6 Nonrace events
SELECT name, location, time
FROM Event
WHERE Event.name NOT LIKE '%Formula 1%';

--#7 Print out all marshals, sorted by location
SELECT name, tracklocation
FROM Marshal
ORDER BY tracklocation;


--#8 Update Marshals to pad their location
UPDATE Marshal
SET tracklocation = printf('T%02d',CAST(substr(tracklocation, 2, 2) AS INTEGER))
WHERE CAST(substr(tracklocation, 2, 2) AS INTEGER) IN
    (SELECT CAST(substr(tracklocation, 2, 2) AS INTEGER) AS value
     FROM Marshal
     WHERE CAST(substr(tracklocation, 2, 2) AS INTEGER) IS substr(tracklocation, 2, 2)
    )
    AND CAST(substr(tracklocation, 2, 2) AS INTEGER) < 10;


--#9 Join team and driver to find total points from the teammates (basically, WCC standings but not using the points column from Team)
SELECT T.employer_id, T.name, SUM(D.points) as points
From Team T, Driver D
WHERE T.employer_id = D.team_id
GROUP BY T.employer_id
ORDER BY points DESC;

--#10 Print out the top 10 results from the race
SELECT driver_id, name, CAST(gpposition AS INTEGER), points AS TotalPoints
From Driver
WHERE CAST(gpposition AS INTEGER) IS gpposition
ORDER BY CAST(gpposition AS INTEGER)
limit 10;

--#11 Print out the top 10 + points, fastest lap included
SELECT drname, teamname, gpposition,
    CASE fastestlap = 1
        WHEN true then points + 1
        else points
    END AS points
FROM(
    SELECT driver_id, Driver.name as drname, Team.name as teamname,
        CASE
            when gpposition = '1' then 25
            when gpposition = '2' then 18
            when gpposition = '3' then 15
            when gpposition = '4' then 12
            when gpposition = '5' then 10
            when gpposition = '6' then 8
            when gpposition = '7' then 6
            when gpposition = '8' then 4
            when gpposition = '9' then 2
            when gpposition = '10' then 1
            else 0 
        END as points, fastestlap, gpposition
    From Driver, Team
    WHERE Driver.team_id = Team.employer_id
    ORDER BY points desc, gpposition asc
    );

--#12 All hands meeting 1 hour before FP1 for all teams
INSERT INTO Task(task_id, employer_id, employee_id, description, deadline)
SELECT row_number() OVER (ORDER BY E1.employer_id ASC), E1.employer_id, employee_id, 'All Hands Meeting', '2021-10-22 10:30:00'
    FROM Employee E1, Employer E2, Team T
    WHERE E1.employer_id = E2.employer_id AND E2.employer_id = T.employer_id;    

--#13 Print out all tasks Alfa Romeo employees are doing
SELECT E1.name, E2.name, description, deadline
    FROM Employee E1, Employer E2, Task T
    WHERE E1.employer_id = E2.employer_id AND T.employer_id = E2.employer_id AND E2.name = 'Alfa Romeo Racing Orlen';

--#14 - Insert into EventEmployers
INSERT INTO EventEmployers(event_id, employer_id) VALUES(1,11);
INSERT INTO EventEmployers(event_id, employer_id) VALUES(1,12);
INSERT INTO EventEmployers(event_id, employer_id) VALUES(2,11);
INSERT INTO EventEmployers(event_id, employer_id) VALUES(2,12);
INSERT INTO EventEmployers(event_id, employer_id) VALUES(3,11);
INSERT INTO EventEmployers(event_id, employer_id) VALUES(3,12);
INSERT INTO EventEmployers(event_id, employer_id) VALUES(4,11);
INSERT INTO EventEmployers(event_id, employer_id) VALUES(4,12);
INSERT INTO EventEmployers(event_id, employer_id) VALUES(5,11);
INSERT INTO EventEmployers(event_id, employer_id) VALUES(5,12);

--#15 - Print out all employers doing official race events
SELECT EvEm.event_id, Ev.name, Em.name 
FROM Event Ev, Employer Em, EventEmployers EvEm
WHERE EvEm.event_id = Ev.event_id AND EvEm.employer_id = Em.employer_id AND Ev.name LIKE '%Formula 1%';

--#16 - Print out the number of employing groups running official race events
SELECT EvEm.event_id, Ev.name, count(distinct Em.name)
FROM Event Ev, Employer Em, EventEmployers EvEm
WHERE EvEm.event_id = Ev.event_id AND EvEm.employer_id = Em.employer_id AND Ev.name LIKE '%Formula 1%'
GROUP BY EvEm.event_id;

--#17 - Print out all drivers that DNFed (did not finish)
SELECT *
FROM Driver
Where gpposition = 'DNF';

-- Update driver to be disqualified
UPDATE Driver
SET gpposition = 'DSQ'
WHERE name = 'Pierre Gasly';

UPDATE Driver
SET gpposition = 'DSQ'
WHERE name = 'Yuki Tsunoda';

UPDATE Driver
SET gpposition = 'DSQ'
WHERE name = 'Fernando Alonso';

--#18 - Set # of penalties = number of disqualified drivers and DELETE them
UPDATE Steward
SET numberofpenalties =
    (SELECT count(*)
    FROM Driver
    WHERE gpposition = 'DSQ'
    );

--DELETE FROM Driver
--WHERE gpposition = 'DSQ';

--#19 - If both drivers of a team got DSQed, fine them 10 points
UPDATE Team
SET points = points - 10
WHERE employer_id IN
    (SELECT distinct(T.employer_id)
    FROM Team T, Driver D
    Where T.employer_id = D.team_id AND D.gpposition = 'DSQ'
    GROUP BY employer_id
    HAVING count(distinct D.driver_id) >= 2
    );

    

--#20 - WCC Race results (how many points the teams scored this race
SELECT T.employer_id, T.name, SUM(Dr.points) as points
From Team T,
    (SELECT driver_id, name,
    CASE fastestlap = 1
        WHEN true then points + 1
        else points
    END AS points, TotalPoints, team_id
    FROM(
        SELECT driver_id, Driver.name, 
            CASE
                when gpposition = 1 then 25
                when gpposition = 2 then 18
                when gpposition = 3 then 15
                when gpposition = 4 then 12
                when gpposition = 5 then 10
                when gpposition = 6 then 8
                when gpposition = 7 then 6
                when gpposition = 8 then 4
                when gpposition = 9 then 2
                when gpposition = 10 then 1
                else 0
                END as points
                ,Driver.points AS TotalPoints, fastestlap, team_id
        From Driver
        ORDER BY gpposition
    )) Dr
WHERE T.employer_id = Dr.team_id
GROUP BY T.employer_id
ORDER BY points DESC;

--#21 Print out the stewards who have given penalties to any of the drivers (based off entries in StewardDriverUpdateTracker)
SELECT St.name, Dr.name, timestamp
FROM Steward St, Driver Dr, StewardDriverUpdateTracker Track
WHERE Track.employee_id = St.employee_id AND Track.driver_id = Dr.driver_id;

--#22 Print out all employees who are working for a company involved in an official race event and their role
SELECT EvEm.event_id, Ev.name, Employee.name, Em.name, Employee.role
FROM Event Ev, Employer Em, EventEmployers EvEm, Employee
WHERE EvEm.event_id = Ev.event_id AND EvEm.employer_id = Em.employer_id AND Employee.employer_id = Em.employer_id AND Ev.name LIKE '%Formula 1%';

--#23 For all employees who are doing so, send them to a debrief 1 hour after the race.
INSERT INTO Task(task_id, employer_id, employee_id, description, deadline)
SELECT row_number() OVER (ORDER BY SQ1.employer_id ASC), SQ1.employer_id, SQ1.employee_id, 'Day After Debrief', SQ1.time
    FROM
    (SELECT DISTINCT Employee.employee_id, Em.employer_id, SQ2.time AS time
    FROM Event Ev, Employer Em, EventEmployers EvEm, Employee,
        (SELECT DATETIME(MAX(time), '+1 hour') AS time  --Get the max time for any officially sanctioned event
        FROM Event
        WHERE name LIKE '%Formula 1%')SQ2
    WHERE EvEm.event_id = Ev.event_id AND EvEm.employer_id = Em.employer_id AND Employee.employer_id = Em.employer_id AND Ev.name LIKE '%Formula 1%') SQ1;

--#24 Give us all the tasks given to employees involved in an official race event, their name, their employer name, and the time
SELECT DISTINCT Employee.name, Em.name, T.description, T.deadline
FROM Task T, Event Ev, Employer Em, EventEmployers EvEm, Employee
WHERE EvEm.event_id = Ev.event_id AND EvEm.employer_id = Em.employer_id AND Employee.employer_id = Em.employer_id
    AND Ev.name LIKE '%Formula 1%' AND T.employee_id = Employee.employee_id;

--#25 Give us all the data regarding the driver (view driver statistics)
SELECT Dr.name, Team.name, Dr.wins, Dr.points, Dr.overallstanding, Dr.gpposition, Dr.fastestlap
FROM Driver Dr, Team
WHERE Dr.driver_id = 1 AND Dr.team_id = Team.employer_id;

SELECT *
FROM Driver;

--INSERT More tuples




















--Testing insert
INSERT INTO Task(task_id, employer_id, employee_id, description, deadline)
    SELECT 21, employer.employer_id, employee_id, 'Im not sure', '2021-10-24 16:00:00'
    FROM employee, employer
    WHERE employee.employer_id = employer.employer_id AND employer.employer_id = 12;

DELETE FROM EventEmployers where event_id = 12;

DELETE FROM Event WHERE event_id =
    (SELECT event_id
    FROM EventEmployers
    WHERE event_id = ? AND employer_id = ?;
    )

SELECT Marshal.employee_id
FROM Employee, Marshal
WHERE Employee.employee_id = Marshal.employee_id;

SELECT Steward.employee_id
FROM Employee, Steward
WHERE Employee.employee_id = Steward.employee_id;

SELECT Event.event_id, Event.name, Event.location, Event.time, count(spec_id)
FROM Event, EventEmployers, SpectatorEvents
WHERE EventEmployers.event_id = Event.event_id AND Event.event_id = SpectatorEvents.event_id AND EventEmployers.employer_id = 12
GROUP BY Event.event_id;

SELECT UNIQUE(Event.event_id), Event.name, Event.location, Event.time

SELECT event_id, name, location, time, SUM(count)
FROM
    (SELECT Event.event_id, Event.name, Event.location, Event.time, count(spec_id) as count
    FROM Event, EventEmployers, SpectatorEvents
    WHERE EventEmployers.event_id = Event.event_id AND Event.event_id = SpectatorEvents.event_id AND EventEmployers.employer_id = 13
    GROUP BY Event.event_id
    UNION
    SELECT Event.event_id, Event.name, Event.location, Event.time, 0 as count
    FROM Event, EventEmployers EE, Employer Emp
    WHERE Event.event_id = EE.event_id AND EE.employer_id = 13 AND Emp.employer_id = EE.employer_id
    GROUP BY Event.event_id
    ORDER BY count)
GROUP BY event_id;

DELETE FROM EventEmployers
WHERE employer_id = 22;

INSERT Into EventEmployers(event_id, employer_id)
SELECT Event.event_id, Employer.employer_id
FROM Event, Employer
WHERE employer_id = 22;

SELECT Dr.name, Team.name, Dr.wins, Dr.points, Dr.overallstanding, Dr.gpposition, Dr.fastestlap
FROM Driver Dr, Team
WHERE Dr.team_id = Team.employer_id AND Team.employer_id = 1;


SELECT Spectator.name, Event.name, Event.location, Event.time
FROM Spectator, SpectatorEvents, Event
WHERE Spectator.spec_id = SpectatorEvents.spec_id AND SpectatorEvents.event_id = Event.event_id AND Spectator.spec_id = 13;