
--Drop all tables in our our database
DROP TABLE Spectator;
DROP TABLE Event;
DROP TABLE Employer;
DROP TABLE Employee;
DROP TABLE Steward;
DROP TABLE Marshal;
DROP TABLE Team;
DROP TABLE Driver;
DROP TABLE EventEmployers;
DROP TABLE Task;
DROP TABLE SpecDriverViewTracker;
DROP TABLE StewardDriverUpdateTracker;
DROP TABLE StewardDriverViewTracker;
DROP TABLE SpecTeamViewTracker;
DROP TABLE StewardTeamUpdateTracker;
DROP TABLE StewardTeamViewTracker;


CREATE TABLE Spectator (
    spec_id INTEGER PRIMARY KEY,
    name VARCHAR(30)
);

CREATE TABLE Event (
    event_id INTEGER PRIMARY KEY,
    name VARCHAR(20),
    location VARCHAR(20),
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
    gpposition INTEGER,
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
    event_id INTEGER,
    employer_id INTEGER,
    task_id INTEGER,
    description VARCHAR(30),
    deadline DATETIME,
    FOREIGN KEY (event_id) REFERENCES event(event_id),
    FOREIGN KEY (employer_id) REFERENCES event(employer_id),
    CONSTRAINT PK PRIMARY KEY (event_id, employer_id, task_id)
);

CREATE TABLE SpecDriverViewTracker (
    spec_id INTEGER,
    driver_id INTEGER,
    timestamp DATETIME,
    FOREIGN KEY (spec_id) REFERENCES Spectator(spec_id),
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id),
    CONSTRAINT PK PRIMARY KEY (spec_id, driver_id)
);

CREATE TABLE StewardDriverUpdateTracker (
    employee_id INTEGER,
    driver_id INTEGER,
    timestamp DATETIME,
    FOREIGN KEY (employee_id) REFERENCES Steward(employee_id),
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id),
    CONSTRAINT PK PRIMARY KEY (employee_id, driver_id)
);

CREATE TABLE StewardDriverViewTracker (
    employee_id INTEGER,
    driver_id INTEGER,
    timestamp DATETIME,
    FOREIGN KEY (employee_id) REFERENCES Steward(employee_id),
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id),
    CONSTRAINT PK PRIMARY KEY (employee_id, driver_id)
);

CREATE TABLE SpecTeamViewTracker (
    spec_id INTEGER ,
    employer_id INTEGER,
    timestamp DATETIME,
    FOREIGN KEY (spec_id) REFERENCES Spectator(spec_id),
    FOREIGN KEY (employer_id) REFERENCES Team(employer_id),
    CONSTRAINT PK PRIMARY KEY (spec_id, employer_id)
);

CREATE TABLE StewardTeamUpdateTracker (
    employee_id INTEGER,
    employer_id INTEGER,
    timestamp DATETIME,
    FOREIGN KEY (employee_id) REFERENCES Steward(employee_id),
    FOREIGN KEY (employer_id) REFERENCES Team(employer_id),
    CONSTRAINT PK PRIMARY KEY (employee_id, employer_id)
);

CREATE TABLE StewardTeamViewTracker (
    employee_id INTEGER,
    employer_id INTEGER,
    timestamp DATETIME,
    FOREIGN KEY (employer_id) REFERENCES Team(employer_id),
    FOREIGN KEY (employee_id) REFERENCES Team(employee_id),
    CONSTRAINT PK PRIMARY KEY (employee_id, employer_id)
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
INSERT INTO Team(employer_id, name, role, wins, points, overallstanding) VALUES (2, 'Scuderia AlphaTauri Honda ', 'f1team', 0, 0, 0);
INSERT INTO Team(employer_id, name, role, wins, points, overallstanding) VALUES (3, 'Alpine F1 Team', 'f1team', 0, 0, 0);
INSERT INTO Team(employer_id, name, role, wins, points, overallstanding) VALUES (4, 'Aston Martin Cognizant F1 Team', 'f1team', 0, 0, 0);
INSERT INTO Team(employer_id, name, role, wins, points, overallstanding) VALUES (5, 'Scuderia Ferrari Mission Winnow', 'f1team', 0, 0, 0);
INSERT INTO Team(employer_id, name, role, wins, points, overallstanding) VALUES (6, 'Uralkali Haas F1 Team', 'f1team', 0, 0, 0);
INSERT INTO Team(employer_id, name, role, wins, points, overallstanding) VALUES (7, 'McLaren F1 Team', 'f1team', 0, 0, 0);
INSERT INTO Team(employer_id, name, role, wins, points, overallstanding) VALUES (8, 'Mercedes-AMG Petronas F1 Team', 'f1team', 0, 0, 0);
INSERT INTO Team(employer_id, name, role, wins, points, overallstanding) VALUES (9, 'Red Bull Racing Honda', 'f1team', 0, 0, 0);
INSERT INTO Team(employer_id, name, role, wins, points, overallstanding) VALUES (10, 'Williams Racing', 'f1team', 0, 0, 0);

--INSERTING DRIVERS
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition) VALUES (1, 1,  'Kimi Raikkonen', 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition) VALUES (2, 1,  'Antonio Giovinazzi', 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition) VALUES (3, 2,  'Pierre Gasly', 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition) VALUES (4, 2,  'Yuki Tsunoda', 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition) VALUES (5, 3,  'Fernando Alonso', 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition) VALUES (6, 3,  'Esteban Ocon', 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition) VALUES (7, 4,  'Sebastian Vettel', 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition) VALUES (8, 4,  'Lance Stroll', 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition) VALUES (9, 5,  'Charles Leclerc', 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition) VALUES (10, 5, 'Carlos Sainz Jr.', 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition) VALUES (11, 6, 'Nikita Mazepin', 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition) VALUES (12, 6, 'Mich Schumacher', 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition) VALUES (13, 7, 'Daniel Ricciardo', 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition) VALUES (14, 7, 'Lando Norris', 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition) VALUES (15, 8, 'Lewis Hamilton', 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition) VALUES (16, 8, 'Valterri Bottas', 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition) VALUES (17, 9, 'Sergio Perez', 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition) VALUES (18, 9, 'Max Verstappen', 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition) VALUES (19, 10,'Nicholas Latifi', 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition) VALUES (20, 10,'George Russell', 0, 0, 0, 0);
INSERT INTO Driver(driver_id, team_id, name, wins, points, overallstanding, gpposition) VALUES (21, 1, 'Robert Kubica', 0, 0, 0, 0);

--INSERTING EVENTS
INSERT INTO Event(event_id, name, location, time) VALUES (1, 'Formula 1 Free Practice 1', 'COTA Track', '2021-10-22 11:30:00');
INSERT INTO Event(event_id, name, location, time) VALUES (2, 'Formula 1 Free Practice 2', 'COTA Track', '2021-10-22 15:30:00');
INSERT INTO Event(event_id, name, location, time) VALUES (3, 'Formula 1 Free Practice 3', 'COTA Track', '2021-10-23 13:00:00');
INSERT INTO Event(event_id, name, location, time) VALUES (4, 'Formula 1 Qualifying', 'COTA Track', '2021-10-23 16:00:00');
INSERT INTO Event(event_id, name, location, time) VALUES (5, 'Formula 1 Grand Prix', 'COTA Track', '2021-10-24 14:00:00');
INSERT INTO Event(event_id, name, location, time) VALUES (6, 'Twenty One Pilots Concert', 'Germania Insurance Super Stage', '2021-10-22 19:30:00');
INSERT INTO Event(event_id, name, location, time) VALUES (7, 'Billy Joel', 'Germania Insurance Super Stage', '2021-10-23 19:30:00');
INSERT INTO Event(event_id, name, location, time) VALUES (8, 'Austin Polka Band', 'BIERGARTEN (T2)', '2021-10-23 12:00:00');

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

INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (11, 12, "Micheal Carter", "Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (12, 12, "Santiago Holloway", "Marshal", "T10");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (13, 12, "Marcos Guzman", "Marshal", "T3");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (14, 12, "Nora Christensen", "Marshal", "T1");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (15, 12, "Misty Silva", "Marshal", "Pitlane");
INSERT INTO Marshal(employee_id, employer_id, name, role, tracklocation) VALUES (16, 12, "Jessica Alonso", "Marshal", "T5");

--INSERTING STEWARDS into STEWARDS and EMPLOYEES
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (17, 11, "Norton Pender","Steward");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (18, 11, "Emily Jeanes","Steward");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (19, 11, "Josue Harden","Steward");
INSERT INTO Employee(employee_id, employer_id, name, role) VALUES (20, 11, "Emiliano Romero","Steward");

INSERT INTO Steward(employee_id, employer_id, name, role, numberofpenalties) VALUES (17, 11, "Norton Pender","Steward", 0);
INSERT INTO Steward(employee_id, employer_id, name, role, numberofpenalties) VALUES (18, 11, "Emily Jeanes","Steward", 0);
INSERT INTO Steward(employee_id, employer_id, name, role, numberofpenalties) VALUES (19, 11, "Josue Harden","Steward", 0);
INSERT INTO Steward(employee_id, employer_id, name, role, numberofpenalties) VALUES (20, 11, "Emiliano Romero","Steward", 0);

--INSERTING SPECTATORS into SPECTATORS
INSERT INTO Spectator(spec_id, name) VALUES (1, "Cindy Marini");
INSERT INTO Spectator(spec_id, name) VALUES (2, "Eduard Tollemache");
INSERT INTO Spectator(spec_id, name) VALUES (3, "Niklas Bagley");
INSERT INTO Spectator(spec_id, name) VALUES (4, "Lara Falk");
INSERT INTO Spectator(spec_id, name) VALUES (5, "Henrik Bader");
INSERT INTO Spectator(spec_id, name) VALUES (6, "Ariel Dias");
INSERT INTO Spectator(spec_id, name) VALUES (7, "Romana Summers");
INSERT INTO Spectator(spec_id, name) VALUES (8, "Eduard Tollemache");
INSERT INTO Spectator(spec_id, name) VALUES (9, "Spongebob Squarepants");
INSERT INTO Spectator(spec_id, name) VALUES (10, "Zuko Ozai");
INSERT INTO Spectator(spec_id, name) VALUES (11, "Shubham Anna");