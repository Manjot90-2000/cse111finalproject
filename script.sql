
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
    FOREIGN KEY (employer_id) REFERENCES employer(employer_id)
);

CREATE TABLE Steward (
    employee_id INTEGER PRIMARY KEY,
    employer_id INTEGER,
    name VARCHAR(30),
    role VARCHAR(30),
    numberofpenalties INTEGER,
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
    FOREIGN KEY (employer_id) REFERENCES employer(employer_id)
);

CREATE TABLE Marshal (
    employee_id INTEGER PRIMARY KEY,
    employer_id INTEGER,
    name VARCHAR(30),
    role VARCHAR(30),
    tracklocation VARCHAR(10),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
    FOREIGN KEY (employer_id) REFERENCES employer(employer_id)
);

CREATE TABLE Team (
    employer_id INTEGER PRIMARY KEY,
    name VARCHAR(30),
    role VARCHAR(30),
    wins INTEGER,
    points FLOAT,
    overallstanding INTEGER,
    FOREIGN KEY (employer_id) REFERENCES employer(employer_id)
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
    FOREIGN KEY (team_id) REFERENCES team(employer_id)
);


CREATE TABLE EventEmployers(
    event_id INTEGER,
    employer_id INTEGER,
    FOREIGN KEY (event_id) REFERENCES event(event_id),
    FOREIGN KEY (employer_id) REFERENCES event(employer_id),
    CONSTRAINT PK PRIMARY KEY (event_id, employer_id)
);

CREATE TABLE Task (
    task_id INTEGER,
    employer_id INTEGER,
    employee_id INTEGER,
    description VARCHAR(30),
    deadline DATETIME,
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
    FOREIGN KEY (employer_id) REFERENCES employer(employer_id),
    CONSTRAINT PK PRIMARY KEY (employee_id, employer_id, task_id)
);

CREATE TABLE SpecDriverViewTracker (
    spec_id INTEGER,
    driver_id INTEGER,
    timestamp DATETIME,
    FOREIGN KEY (spec_id) REFERENCES Spectator(spec_id),
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id),
    CONSTRAINT PK PRIMARY KEY (spec_id, driver_id, timestamp)
);

CREATE TABLE StewardDriverUpdateTracker (
    employee_id INTEGER,
    driver_id INTEGER,
    timestamp DATETIME,
    FOREIGN KEY (employee_id) REFERENCES Steward(employee_id),
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id),
    CONSTRAINT PK PRIMARY KEY (employee_id, driver_id, timestamp)
);

CREATE TABLE StewardDriverViewTracker (
    employee_id INTEGER,
    driver_id INTEGER,
    timestamp DATETIME,
    FOREIGN KEY (employee_id) REFERENCES Steward(employee_id),
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id),
    CONSTRAINT PK PRIMARY KEY (employee_id, driver_id, timestamp)
);

CREATE TABLE SpecTeamViewTracker (
    spec_id INTEGER ,
    employer_id INTEGER,
    timestamp DATETIME,
    FOREIGN KEY (spec_id) REFERENCES Spectator(spec_id),
    FOREIGN KEY (employer_id) REFERENCES Team(employer_id),
    CONSTRAINT PK PRIMARY KEY (spec_id, employer_id, timestamp)
);

CREATE TABLE StewardTeamUpdateTracker (
    employee_id INTEGER,
    employer_id INTEGER,
    timestamp DATETIME,
    FOREIGN KEY (employee_id) REFERENCES Steward(employee_id),
    FOREIGN KEY (employer_id) REFERENCES Team(employer_id),
    CONSTRAINT PK PRIMARY KEY (employee_id, employer_id, timestamp)
);

CREATE TABLE StewardTeamViewTracker (
    employee_id INTEGER,
    employer_id INTEGER,
    timestamp DATETIME,
    FOREIGN KEY (employer_id) REFERENCES Team(employer_id),
    FOREIGN KEY (employee_id) REFERENCES Team(employee_id),
    CONSTRAINT PK PRIMARY KEY (employee_id, employer_id, timestamp)
);

--createing table for spectator events
CREATE TABLE SpectatorEvents (
    spec_id INTEGER,
    event_id INTEGER,
    FOREIGN KEY (spec_id) REFERENCES Spectator(spec_id),
    FOREIGN KEY (event_id) REFERENCES Event(event_id),
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
SELECT driver_id, name,
    CASE fastestlap = 1
        WHEN true then points + 1
        else points
    END AS points, TotalPoints
FROM(
    SELECT driver_id, name, 
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
        END as points
        ,points AS TotalPoints, fastestlap
    From Driver
    WHERE CAST(gpposition AS INTEGER) IS gpposition
    ORDER BY CAST(gpposition AS INTEGER)
    limit 10
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

--Testing insert
INSERT INTO Task(task_id, employer_id, employee_id, description, deadline)
    SELECT 21, employer.employer_id, employee_id, 'Im not sure', '2021-10-24 16:00:00'
    FROM employee, employer
    WHERE employee.employer_id = employer.employer_id AND employer.employer_id = 12;