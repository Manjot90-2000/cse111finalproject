import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Scanner;
import java.util.Date;

public class phase3 {
    private Connection c = null;
    private String dbName;
    private boolean isConnected = false;

    private void openConnection(String _dbName) {
        dbName = _dbName;

        if (isConnected == false) {
            System.out.println("Opening: " + _dbName);
            try {
                String connectionString = new String("jdbc:sqlite:");
                connectionString += dbName;

                Class.forName("org.sqlite.JDBC"); // registers jdbc driver

                c = DriverManager.getConnection(connectionString); // open connection
                c.setAutoCommit(false); // disables autotransactions

                //Statement s = c.createStatement();
                //s.executeUpdate("PRAGMA foreign_keys = ON; ");

                PreparedStatement s1 = c.prepareStatement("PRAGMA foreign_keys = ON; ");
                s1.executeUpdate();

                PreparedStatement s2 = c.prepareStatement("PRAGMA foreign_keys; ");
                ResultSet set = s2.executeQuery();

                //while(set.next()){
                    //int val = set.getInt(1);
                    //System.out.printf("%-10d\n", val);
                //}

                s1.close();
                s2.close();
                set.close();

                isConnected = true;
                System.out.print("Connected. ");
            } catch (Exception e) { // catch errors
                System.err.println(e.getClass().getName() + ": " + e.getMessage());
                System.exit(0);
            }
        }
    }

    private void closeConnection() {
        if (true == isConnected) {
            System.out.println("Close database: " + dbName);

            try {
                c.close();
                isConnected = false;
                dbName = "";
                System.out.println("Closed the database");
            } catch (Exception e) {
                System.err.println(e.getClass().getName() + ": " + e.getMessage());
                System.exit(0);
            }

        }
    }

    // SPECTATOR METHODS
    private int insertSpectator(String name) {
        try {
            String maxSpecQ = "SELECT MAX(spec_id) FROM Spectator; ";
            PreparedStatement maxSpec = c.prepareStatement(maxSpecQ);
            ResultSet maxresult = maxSpec.executeQuery();
            int specID = maxresult.getInt(1) + 1;

            String insertSpecQ = "INSERT INTO Spectator(spec_id, name) VALUES (?,?)";
            PreparedStatement insertSpec = c.prepareStatement(insertSpecQ);
            // ParameterMetaData data = insertTasks.getParameterMetaData();
            // System.out.println(data.getParameterCount());
            insertSpec.setInt(1, specID);
            insertSpec.setString(2, name);
            insertSpec.executeUpdate();

            c.commit();
            maxresult.close();
            maxSpec.close();
            insertSpec.close();
            return specID;
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
        return -1;
    }

    private void printEvents() {
        System.out.println("Printing Events");
        System.out.printf("%-10s %-30s %30s %25s\n",
                "Event ID", "Event Name", "Location", "Time");
        try {
            Statement stmt = c.createStatement();
            String printEvents = "SELECT * " +
                    "FROM Event ";

            ResultSet events = stmt.executeQuery(printEvents);

            while (events.next()) {
                String id = events.getString(1);
                String event = events.getString(2);
                String location = events.getString(3);
                String time = events.getString(4);
                System.out.printf("%-10s %-30s %30s %25s\n", id, event, location, time);
            }
            events.close();
            stmt.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void viewSpecEvents(int _spec_id) {
        System.out.printf("%-8s %-30s %-30s %-50s %-20s\n",
                "Event ID", "User", "Event Name", "Location", "Time");
        try {
            String eventList = "SELECT Event.event_id, Spectator.name, Event.name, Event.location, Event.time " +
            "FROM Spectator, SpectatorEvents, Event " +
            "WHERE Spectator.spec_id = SpectatorEvents.spec_id AND SpectatorEvents.event_id = Event.event_id AND Spectator.spec_id = ?; ";
            PreparedStatement list = c.prepareStatement(eventList);
            list.setInt(1, _spec_id);
            ResultSet listofEvents = list.executeQuery();

            while (listofEvents.next()) {
                int eventid = listofEvents.getInt(1);
                String specname = listofEvents.getString(2);
                String eventname = listofEvents.getString(3);
                String location = listofEvents.getString(4);
                String time = listofEvents.getString(5);
                System.out.printf("%-8s %-30s %-30s %-50s %-20s\n", eventid, specname, eventname, location, time);
            }

            listofEvents.close();
            list.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void deleteSpecEvents(int _spec_id, int _event_id) {
        try {
            String specEventDelete = "DELETE FROM SpectatorEvents WHERE spec_id = ? AND event_id = ?; ";
            PreparedStatement deletestmt = c.prepareStatement(specEventDelete);
            deletestmt.setInt(1, _spec_id);
            deletestmt.setInt(2, _event_id);
            deletestmt.executeUpdate();

            c.commit();
            deletestmt.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    // NOTE: Consider using a location field in Spectator.
    private int getSpecID(String _name) {
        try {
            String getID = "SELECT spec_id " +
                    "FROM Spectator " +
                    "WHERE name = ?; ";
            PreparedStatement fetch = c.prepareStatement(getID);
            fetch.setString(1, _name);
            ResultSet id = fetch.executeQuery();
            int idvalue = id.getInt(1);

            fetch.close();
            id.close();
            return idvalue;
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
        return -1;
    }

    private int getDriverID(String _name) {
        try {
            String getID = "SELECT driver_id " +
                    "FROM Driver " +
                    "WHERE name = ?; ";
            PreparedStatement fetch = c.prepareStatement(getID);
            fetch.setString(1, _name);
            ResultSet id = fetch.executeQuery();
            int idvalue = id.getInt(1);

            fetch.close();
            id.close();
            return idvalue;
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
        return -1;
    }

    private int getTeamID(String _name) {
        try {
            String getID = "SELECT employer_id " +
                    "FROM Team " +
                    "WHERE name = ?; ";
            PreparedStatement fetch = c.prepareStatement(getID);
            fetch.setString(1, _name);
            ResultSet id = fetch.executeQuery();
            int idvalue = id.getInt(1);

            fetch.close();
            id.close();
            return idvalue;
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
        return -1;
    }

    private String getTeamName(int team_id) {
        try {
            String getID = "SELECT name " +
                    "FROM Team " +
                    "WHERE employer_id = ?; ";
            PreparedStatement fetch = c.prepareStatement(getID);
            fetch.setInt(1, team_id);
            ResultSet names = fetch.executeQuery();
            String nameval = names.getString(1);

            fetch.close();
            names.close();
            return nameval;
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
        return "";
    }

    private void insertSpectatorEvents(int _spec_id, int _event_id) {
        try {
            String insertSpecEv = "INSERT INTO SpectatorEvents(spec_id, event_id) " +
                    "VALUES(?,?); ";
            PreparedStatement insert = c.prepareStatement(insertSpecEv);
            insert.setInt(1, _spec_id);
            insert.setInt(2, _event_id);
            insert.executeUpdate();

            c.commit();
            insert.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void viewDriverStandings() {
        System.out.printf("%-30s %10s\n",
                "Name", "Points");
        try {
            String viewWDC = "SELECT name, points " +
                    "FROM Driver " +
                    "ORDER BY points DESC; ";
            PreparedStatement view = c.prepareStatement(viewWDC);
            ResultSet WDC = view.executeQuery();

            while (WDC.next()) {
                String name = WDC.getString(1);
                double points = WDC.getDouble(2);
                System.out.printf("%-30s %10.1f\n", name, points);
            }
            view.close();
            WDC.close();

        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void viewTeamStandings() {
        System.out.printf("%-35s %10s\n", "Name", "Points");
        try {
            String viewWCC = "SELECT name, points " +
                    "FROM Team " +
                    "ORDER BY points DESC; ";
            PreparedStatement view = c.prepareStatement(viewWCC);
            ResultSet WCC = view.executeQuery();

            while (WCC.next()) {
                String name = WCC.getString(1);
                double points = WCC.getDouble(2);
                System.out.printf("%-35s %10.1f\n", name, points);
            }

            view.close();
            WCC.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void viewDriverStatistics(String _driver_name) {
        System.out.printf("%-30s %-35s %-5s %-7s %-17s %-12s %-12s\n",
                "Driver Name", "Team Name", "Wins", "Points", "Overall Standing", "GP Position", "Fastest Lap");
        try {
            String viewDriver = "SELECT Dr.name, Team.name, Dr.wins, Dr.points, Dr.overallstanding, Dr.gpposition, Dr.fastestlap "
                    +
                    "FROM Driver Dr, Team " +
                    "WHERE Dr.name = ? AND Dr.team_id = Team.employer_id; ";
            PreparedStatement view = c.prepareStatement(viewDriver);
            view.setString(1, _driver_name);
            ResultSet driver = view.executeQuery();

            while (driver.next()) {
                String drivername = driver.getString(1);
                String teamname = driver.getString(2);
                int wins = driver.getInt(3);
                double points = driver.getDouble(4);
                int overallstanding = driver.getInt(5);
                String gpposition = driver.getString(6);
                int fastestlap = driver.getInt(7);
                System.out.printf("%-30s %-35s %-5d %-7.1f %-17d %-12s %-12d\n", drivername, teamname, wins, points,
                        overallstanding, gpposition, fastestlap);
            }

            view.close();
            driver.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void viewDriverPairStatistics(String _team_name) {
        System.out.printf("%-30s %-35s %-5s %-7s %-17s %-12s %-12s\n",
                "Driver Name", "Team Name", "Wins", "Points", "Overall Standing", "GP Position", "Fastest Lap");
        try {
            String viewDriver = "SELECT Dr.name, Team.name, Dr.wins, Dr.points, Dr.overallstanding, Dr.gpposition, Dr.fastestlap "
                    +
                    "FROM Driver Dr, Team " +
                    "WHERE Dr.team_id = Team.employer_id AND Team.name = ?; ";
            PreparedStatement view = c.prepareStatement(viewDriver);
            view.setString(1, _team_name);
            ResultSet driver = view.executeQuery();

            while (driver.next()) {
                String drivername = driver.getString(1);
                String teamname = driver.getString(2);
                int wins = driver.getInt(3);
                double points = driver.getDouble(4);
                int overallstanding = driver.getInt(5);
                String gpposition = driver.getString(6);
                int fastestlap = driver.getInt(7);
                System.out.printf("%-30s %-35s %-5d %-7.1f %-17d %-12s %-12d\n", drivername, teamname, wins, points,
                        overallstanding, gpposition, fastestlap);
            }

            view.close();
            driver.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void viewTeamStatistics(String _team_name) {
        System.out.printf("%-35s %-5s %-7s %-17s\n",
                "Team Name", "Wins", "Points", "Overall Standing");
        try {
            String viewTeam = "SELECT Team.name, Team.wins, Team.points, Team.overallstanding " +
                    "FROM Team " +
                    "WHERE Team.name = ?; ";
            PreparedStatement view = c.prepareStatement(viewTeam);
            view.setString(1, _team_name);
            ResultSet team = view.executeQuery();

            while (team.next()) {
                String name = team.getString(1);
                int wins = team.getInt(2);
                double points = team.getDouble(3);
                int standing = team.getInt(4);
                System.out.printf("%-35s %-5s %-7.1f %-17d\n", name, wins, points, standing);
            }

            view.close();
            team.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void insertSpecDriverViewTracker(int _spec_id, int _driver_id) {
        try {
            String insertSDVT = "INSERT INTO SpecDriverViewTracker(spec_id, driver_id, timestamp) " +
                    "VALUES(?,?,?); ";
            PreparedStatement insert = c.prepareStatement(insertSDVT);

            Date date = new Date();
            Timestamp arg = new java.sql.Timestamp(date.getTime());
            String formatarg = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(arg);

            insert.setInt(1, _spec_id);
            insert.setInt(2, _driver_id);
            insert.setString(3, formatarg);
            insert.executeUpdate();

            c.commit();
            insert.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void insertSpecTeamViewTracker(int _spec_id, int _team_id) {
        try {
            String insertSTVT = "INSERT INTO SpecTeamViewTracker(spec_id, employer_id, timestamp) " +
                    "VALUES(?,?,?); ";
            PreparedStatement insert = c.prepareStatement(insertSTVT);

            Date date = new Date();
            Timestamp arg = new java.sql.Timestamp(date.getTime());
            String formatarg = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(arg);

            insert.setInt(1, _spec_id);
            insert.setInt(2, _team_id);
            insert.setString(3, formatarg);
            insert.executeUpdate();

            c.commit();
            insert.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    // EMPLOYER Methods
    private int getEmployerID(String _name) {
        try {
            String getID = "SELECT employer_id " +
                    "FROM employer " +
                    "WHERE name = ?; ";
            PreparedStatement fetch = c.prepareStatement(getID);
            fetch.setString(1, _name);
            ResultSet id = fetch.executeQuery();
            int idvalue = id.getInt(1);

            fetch.close();
            id.close();
            return idvalue;
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
        return -1;
    }

    private int getEmployerIDNoF1Teams(String _name) {
        try {
            String getID = "SELECT employer_id " +
                    "FROM employer " +
                    "WHERE name = ? ANd role <> 'f1team'; ";
            PreparedStatement fetch = c.prepareStatement(getID);
            fetch.setString(1, _name);
            ResultSet id = fetch.executeQuery();
            int idvalue = id.getInt(1);

            fetch.close();
            id.close();
            return idvalue;
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
        return -1;
    }


    private void createTaskAll(int _employer_id, String _description, String _deadline) {
        try {
            String maxTaskQ = "SELECT MAX(task_id) FROM Task WHERE employer_id = ?; ";
            PreparedStatement maxTask = c.prepareStatement(maxTaskQ);
            maxTask.setInt(1, _employer_id);
            ResultSet maxresult = maxTask.executeQuery();
            int taskID = maxresult.getInt(1) + 1;

            String insertTaskAll = "INSERT INTO Task(task_id, employer_id, employee_id, description, deadline) " +
                    "SELECT ?, employer.employer_id, employee_id, ?, ? " +
                    "FROM employee, employer " +
                    "WHERE employee.employer_id = employer.employer_id AND employer.employer_id = ?; ";
            PreparedStatement insertTasks = c.prepareStatement(insertTaskAll);
            // ParameterMetaData data = insertTasks.getParameterMetaData();
            // System.out.println(data.getParameterCount());
            insertTasks.setInt(1, taskID);
            insertTasks.setString(2, _description);
            insertTasks.setString(3, _deadline);
            insertTasks.setInt(4, _employer_id);
            insertTasks.executeUpdate();

            c.commit();
            maxresult.close();
            maxTask.close();
            insertTasks.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void createTaskOne(int _employer_id, String _description, String _deadline, int _employee_id) {
        try {
            String maxTaskQ = "SELECT MAX(task_id) FROM Task WHERE employer_id = ?; ";
            PreparedStatement maxTask = c.prepareStatement(maxTaskQ);
            maxTask.setInt(1, _employer_id);
            ResultSet maxresult = maxTask.executeQuery();
            int taskID = maxresult.getInt(1) + 1;

            String insertTaskOne = "INSERT INTO Task(task_id, employer_id, employee_id, description, deadline) " +
                    "SELECT ?, employer.employer_id, employee_id, ?, ? " +
                    "FROM employee, employer " +
                    "WHERE employee.employer_id = employer.employer_id AND employer.employer_id = ? AND employee.employee_id = ?; ";
            PreparedStatement insertTasks = c.prepareStatement(insertTaskOne);
            // ParameterMetaData data = insertTasks.getParameterMetaData();
            // System.out.println(data.getParameterCount());
            insertTasks.setInt(1, taskID);
            insertTasks.setString(2, _description);
            insertTasks.setString(3, _deadline);
            insertTasks.setInt(4, _employer_id);
            insertTasks.setInt(5, _employee_id);
            insertTasks.executeUpdate();

            c.commit();
            maxresult.close();
            maxTask.close();
            insertTasks.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void viewTasks(int _employer_id) {
        System.out.printf("%-7s %-12s %-12s %-75s %-20s\n",
                "Task ID", "Employer ID", "Employee ID", "Description", "Deadline");
        try {
            String taskList = "SELECT * FROM Task WHERE employer_id = ?; ";
            PreparedStatement list = c.prepareStatement(taskList);
            list.setInt(1, _employer_id);
            ResultSet listOfTasks = list.executeQuery();

            while (listOfTasks.next()) {
                int taskID = listOfTasks.getInt(1);
                int employeeid = listOfTasks.getInt(2);
                int employerid = listOfTasks.getInt(3);
                String description = listOfTasks.getString(4);
                String deadline = listOfTasks.getString(5);
                System.out.printf("%-7d %-12d %-12d %-75s %-20s\n",
                        taskID, employeeid, employerid, description, deadline);
            }
            listOfTasks.close();
            list.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void deleteTask(int _employer_id, int specifictask) {

        try {
            String deleteTaskString = "DELETE FROM Task WHERE employer_id = ? AND task_id = ?";
            PreparedStatement deleteTask = c.prepareStatement(deleteTaskString);
            deleteTask.setInt(1, _employer_id);
            deleteTask.setInt(2, specifictask);
            deleteTask.executeUpdate();

            c.commit();
            deleteTask.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void viewEmployees(int _employer_id) {
        try {
            System.out.println("");
            System.out.printf("%-12s %-30s %-10s\n",
                    "Employee ID", "Name", "Role");

            String employeeList = "SELECT employee_id, name, role FROM Employee WHERE employer_id = ?; ";
            PreparedStatement list2 = c.prepareStatement(employeeList);
            list2.setInt(1, _employer_id);
            ResultSet employeelist = list2.executeQuery();

            while (employeelist.next()) {
                int id = employeelist.getInt(1);
                String name = employeelist.getString(2);
                String role = employeelist.getString(3);
                System.out.printf("%-12d %-30s %-10s\n", id, name, role);
            }
            list2.close();
            employeelist.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void assignTask(int _employer_id, int _specifictask, int _employee_id) {
        try {
            // System.out.println(_specfictask + " " + _employer_id + " " + _employee_id);

            String assignTaskOne = "INSERT INTO Task(task_id, employer_id, employee_id, description, deadline) " +
                    "SELECT task_id, employer.employer_id, employee.employee_id, description, deadline " +
                    "FROM employee, employer, task " +
                    "WHERE employee.employer_id = employer.employer_id AND task_id = ? AND employer.employer_id = ? AND employee.employee_id = ? "
                    +
                    "AND employer.employer_id = task.employer_id " +
                    "LIMIT 1; ";
            PreparedStatement assignTask = c.prepareStatement(assignTaskOne);
            assignTask.setInt(1, _specifictask);
            assignTask.setInt(2, _employer_id);
            assignTask.setInt(3, _employee_id);
            assignTask.executeUpdate();

            // ResultSet assign = assignTask.executeQuery();

            // while (assign.next()) {
            // int id1 = assign.getInt(1);
            // int id2 = assign.getInt(2);
            // int id3 = assign.getInt(3);
            // System.out.printf("%-12d %-12d %-12d\n", id1, id2, id3);
            // }

            c.commit();
            assignTask.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void createEvent(int _employer_id, String name, String location, String time) {
        try {
            String maxEventQ = "SELECT MAX(event_id) FROM Event; ";
            PreparedStatement maxEvent = c.prepareStatement(maxEventQ);
            ResultSet maxresult = maxEvent.executeQuery();
            int _event_id = maxresult.getInt(1) + 1;

            String insertEvent = "INSERT INTO Event(event_id, name, location, time) VALUES(?,?,?,?); ";
            PreparedStatement insert = c.prepareStatement(insertEvent);

            String insertEventEmployer = "INSERT INTO EventEmployers(event_id, employer_id) VALUES(?,?); ";
            PreparedStatement insertEventEmpl = c.prepareStatement(insertEventEmployer);

            // Date date = new Date();
            // Timestamp arg = new java.sql.Timestamp(date.getTime());
            // String formatarg = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(arg);

            insert.setInt(1, _event_id);
            insert.setString(2, name);
            insert.setString(3, location);
            insert.setString(4, time);
            insert.executeUpdate();

            insertEventEmpl.setInt(1, _event_id);
            insertEventEmpl.setInt(2, _employer_id);
            // System.out.println(_event_id + " " + _employer_id);
            insertEventEmpl.executeUpdate();

            c.commit();
            insert.close();
            insertEventEmpl.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void viewEventFromEmployer(int _employer_id) {
        System.out.printf("%-8s %-50s %-30s %-50s %-20s\n",
                "Event ID", "Employer Name", "Event Name", "Location", "Time");
        try {
            String eventList = "SELECT Event.event_id, Emp.name, Event.name, Event.location, Event.time " +
                    "FROM Event, EventEmployers EE, Employer Emp " +
                    "WHERE Event.event_id = EE.event_id AND EE.employer_id = ? AND Emp.employer_id = EE.employer_id ";
            PreparedStatement list = c.prepareStatement(eventList);
            list.setInt(1, _employer_id);
            ResultSet listofEvents = list.executeQuery();

            while (listofEvents.next()) {
                int eventid = listofEvents.getInt(1);
                String emplname = listofEvents.getString(2);
                String eventname = listofEvents.getString(3);
                String location = listofEvents.getString(4);
                String time = listofEvents.getString(5);
                System.out.printf("%-8s %-50s %-30s %-50s %-20s\n", eventid, emplname, eventname, location, time);
            }

            listofEvents.close();
            list.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void viewEvents() {
        System.out.printf("%-8s %-30s %-50s %-20s\n",
                "Event ID", "Event Name", "Location", "Time");
        try {
            String eventList = "SELECT Event.event_id, Event.name, Event.location, Event.time " +
                    "FROM Event; ";
            PreparedStatement list = c.prepareStatement(eventList);
            // list.setInt(1, _employer_id);
            ResultSet listofEvents = list.executeQuery();

            while (listofEvents.next()) {
                int eventid = listofEvents.getInt(1);
                String eventname = listofEvents.getString(2);
                String location = listofEvents.getString(3);
                String time = listofEvents.getString(4);
                System.out.printf("%-8s %-30s %-50s %-20s\n", eventid, eventname, location, time);
            }

            listofEvents.close();
            list.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void deleteEvent(int _employer_id, int specificevent) {
        try {
            String deleteEventString = "DELETE FROM Event WHERE event_id = " +
                    "(SELECT event_id FROM EventEmployers WHERE event_id = ? AND employer_id = ?); ";
            PreparedStatement deleteEvent = c.prepareStatement(deleteEventString);
            deleteEvent.setInt(1, specificevent);
            deleteEvent.setInt(2, _employer_id);
            deleteEvent.executeUpdate();

            deleteEventString = "DELETE FROM EventEmployers WHERE event_id = ? AND employer_id = ?";
            deleteEvent = c.prepareStatement(deleteEventString);
            deleteEvent.setInt(1, specificevent);
            deleteEvent.setInt(2, _employer_id);
            deleteEvent.executeUpdate();

            deleteEventString = "DELETE FROM SpectatorEvents WHERE event_id = ?";
            deleteEvent = c.prepareStatement(deleteEventString);
            deleteEvent.setInt(1, specificevent);
            deleteEvent.executeUpdate();

            c.commit();
            deleteEvent.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void assignEvent(int _employer_id, int specificevent) {
        try {
            String assignTaskString = "INSERT INTO EventEmployers (event_id, employer_id) VALUES(?,?); ";
            PreparedStatement assignEvent = c.prepareStatement(assignTaskString);
            assignEvent.setInt(1, specificevent);
            assignEvent.setInt(2, _employer_id);
            assignEvent.executeUpdate();

            c.commit();
            assignEvent.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void viewEventsPopularity(int _employer_id) {
        System.out.printf("%-8s %-30s %-50s %-20s %-20s\n",
                "Event ID", "Event Name", "Location", "Time", "Number of spectators");
        try {
            String eventList = "SELECT event_id, name, location, time, SUM(count) " +
            "FROM " +
                "(SELECT Event.event_id, Event.name, Event.location, Event.time, count(spec_id) as count " +
                "FROM Event, EventEmployers, SpectatorEvents " +
                "WHERE EventEmployers.event_id = Event.event_id AND Event.event_id = SpectatorEvents.event_id AND EventEmployers.employer_id = ? " +
                "GROUP BY Event.event_id " +
                "UNION " +
                "SELECT Event.event_id, Event.name, Event.location, Event.time, 0 as count " +
                "FROM Event, EventEmployers EE, Employer Emp " +
                "WHERE Event.event_id = EE.event_id AND EE.employer_id = ? AND Emp.employer_id = EE.employer_id " +
                "GROUP BY Event.event_id " +
                "ORDER BY count) " +
            "GROUP BY event_id; ";
            PreparedStatement list = c.prepareStatement(eventList);
            list.setInt(1, _employer_id);
            list.setInt(2, _employer_id);
            ResultSet listofEvents = list.executeQuery();

            while (listofEvents.next()) {
                int eventid = listofEvents.getInt(1);
                String eventname = listofEvents.getString(2);
                String location = listofEvents.getString(3);
                String time = listofEvents.getString(4);
                int popularity = listofEvents.getInt(5);
                System.out.printf("%-8s %-30s %-50s %-20s %-20s\n", eventid, eventname, location, time, popularity);
            }

            listofEvents.close();
            list.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }


    private void viewWeekendResults(int viewerid, String role) {
        System.out.printf("%-30s %-35s %-12s %-7s\n",
                "Driver Name", "Team Name", "GP Position", "Points");

        try {
            String weekendResultList = "SELECT drname, teamname, gpposition, " +
                    "CASE fastestlap = 1 " +
                    "WHEN true then points + 1 " +
                    "else points " +
                    "END AS points " +
                    "FROM( " +
                    "SELECT driver_id, Driver.name as drname, Team.name as teamname, " +
                    "CASE " +
                    "when gpposition = '1' then 25 " +
                    "when gpposition = '2' then 18 " +
                    "when gpposition = '3' then 15 " +
                    "when gpposition = '4' then 12 " +
                    "when gpposition = '5' then 10 " +
                    "when gpposition = '6' then 8 " +
                    "when gpposition = '7' then 6 " +
                    "when gpposition = '8' then 4 " +
                    "when gpposition = '9' then 2 " +
                    "when gpposition = '10' then 1 " +
                    "else 0 " +
                    "END as points, fastestlap, gpposition " +
                    "From Driver, Team " +
                    "WHERE Driver.team_id = Team.employer_id " +
                    "ORDER BY points desc, gpposition asc); ";
            PreparedStatement list = c.prepareStatement(weekendResultList);
            ResultSet weekendResults = list.executeQuery();

            while (weekendResults.next()) {
                String drivername = weekendResults.getString(1);
                String teamname = weekendResults.getString(2);
                String gpposition = weekendResults.getString(3);
                int points = weekendResults.getInt(4);
                System.out.printf("%-30s %-35s %-12s %-7d\n", drivername, teamname, gpposition, points);
            }
            if (role.equals("sp")) {
                insertSpecDriverViewTracker(viewerid, 0);
            } else if (role.equals("st")) {
                insertStewardDriverViewTracker(viewerid, 0);
            }

            weekendResults.close();
            list.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private int getEmployeeID(String _name, String role) {
        try {
            String getID = "";
            if (role.equals("marshal")) {
                getID = "SELECT Marshal.employee_id " +
                        "FROM Employee, Marshal " +
                        "WHERE Employee.employee_id = Marshal.employee_id AND marshal.name = ?; ";
            }
            if (role.equals("steward")) {
                getID = "SELECT Steward.employee_id " +
                        "FROM Employee, Steward " +
                        "WHERE Employee.employee_id = Steward.employee_id AND steward.name = ?; ";
            } else {
                getID = "SELECT employee_id " +
                        "FROM Employee " +
                        "WHERE name = ?; ";
            }
            PreparedStatement fetch = c.prepareStatement(getID);
            fetch.setString(1, _name);
            ResultSet id = fetch.executeQuery();
            int idvalue = id.getInt(1);

            fetch.close();
            id.close();
            return idvalue;
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
        return -1;
    }

    private int getEmployerIDFromEmployee(String _name) {
        try {
            String getID = "SELECT Employer.employer_id " +
                    "FROM Employee, Employer " +
                    "WHERE Employee.name = ? AND Employee.employer_id = Employer.employer_id; ";
            PreparedStatement fetch = c.prepareStatement(getID);
            fetch.setString(1, _name);
            ResultSet id = fetch.executeQuery();
            int idvalue = id.getInt(1);

            fetch.close();
            id.close();
            return idvalue;
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
        return -1;
    }

    private void viewIndividualTasks(int _employee_id, int _employer_id) {
        System.out.printf("%-7s %-75s %-20s\n",
                "Task ID", "Description", "Deadline");
        try {
            String taskList = "SELECT task_id, description, deadline FROM Task WHERE employer_id = ? AND employee_id = ?; ";
            PreparedStatement list = c.prepareStatement(taskList);
            list.setInt(1, _employer_id);
            list.setInt(2, _employee_id);
            ResultSet listOfTasks = list.executeQuery();

            while (listOfTasks.next()) {
                int taskID = listOfTasks.getInt(1);
                String description = listOfTasks.getString(2);
                String deadline = listOfTasks.getString(3);
                System.out.printf("%-7d %-75s %-20s\n",
                        taskID, description, deadline);
            }

            listOfTasks.close();
            list.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void insertStewardDriverViewTracker(int _steward_id, int _driver_id) {
        try {
            String insertSTEWARDDVT = "INSERT INTO StewardDriverViewTracker(employee_id, driver_id, timestamp) " +
                    "VALUES(?,?,?); ";
            PreparedStatement insert = c.prepareStatement(insertSTEWARDDVT);

            Date date = new Date();
            Timestamp arg = new java.sql.Timestamp(date.getTime());
            String formatarg = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(arg);

            insert.setInt(1, _steward_id);
            insert.setInt(2, _driver_id);
            insert.setString(3, formatarg);
            insert.executeUpdate();

            c.commit();
            insert.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void insertStewardTeamViewTracker(int _steward_id, int _team_id) {
        try {
            String insertSTVT = "INSERT INTO StewardTeamViewTracker(employee_id, employer_id, timestamp) " +
                    "VALUES(?,?,?); ";
            PreparedStatement insert = c.prepareStatement(insertSTVT);

            Date date = new Date();
            Timestamp arg = new java.sql.Timestamp(date.getTime());
            String formatarg = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(arg);

            insert.setInt(1, _steward_id);
            insert.setInt(2, _team_id);
            insert.setString(3, formatarg);
            insert.executeUpdate();

            c.commit();
            insert.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    public int getTeamIDFromDriver(int _driver_id) {
        try {
            String getID = "SELECT employer_id " +
                    "FROM Team, Driver " +
                    "WHERE Team.employer_id = Driver.team_id AND driver_id = ?; ";
            PreparedStatement fetch = c.prepareStatement(getID);
            fetch.setInt(1, _driver_id);
            ResultSet id = fetch.executeQuery();
            int idvalue = id.getInt(1);

            fetch.close();
            id.close();
            return idvalue;
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
        return -1;
    }

    private void updateDriverStatistics(int _driver_id, int difference) {
        try {
            String update = "UPDATE Driver SET points = points - ? WHERE driver_id = ?";
            PreparedStatement updateDriver = c.prepareStatement(update);
            updateDriver.setInt(1, difference);
            updateDriver.setInt(2, _driver_id);
            updateDriver.executeUpdate();

            c.commit();
            updateDriver.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void updateTeamStatistics(int _team_id, int difference) {
        try {
            String update = "UPDATE Team SET points = points - ? WHERE employer_id = ?";
            PreparedStatement updateTeam = c.prepareStatement(update);
            updateTeam.setInt(1, difference);
            updateTeam.setInt(2, _team_id);
            updateTeam.executeUpdate();

            c.commit();
            updateTeam.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void updateDriverStatisticsPosition(int _driver_id, int position) {
        try {
            String update = "UPDATE Driver SET overallstanding = ? WHERE driver_id = ?";
            PreparedStatement updateDriver = c.prepareStatement(update);
            updateDriver.setInt(1, position);
            updateDriver.setInt(2, _driver_id);
            updateDriver.executeUpdate();

            c.commit();
            updateDriver.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void updateTeamStatisticsPosition(int _team_id, int position) {
        try {
            String update = "UPDATE Team SET overallstanding = ? WHERE employer_id = ?";
            PreparedStatement updateTeam = c.prepareStatement(update);
            updateTeam.setInt(1, position);
            updateTeam.setInt(2, _team_id);
            updateTeam.executeUpdate();

            c.commit();
            updateTeam.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void insertStewardDriverUpdateTracker(int _steward_id, int _driver_id) {
        try {
            String insertSTEWARDDVT = "INSERT INTO StewardDriverUpdateTracker(employee_id, driver_id, timestamp) " +
                    "VALUES(?,?,?); ";
            PreparedStatement insert = c.prepareStatement(insertSTEWARDDVT);

            Date date = new Date();
            Timestamp arg = new java.sql.Timestamp(date.getTime());
            String formatarg = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(arg);

            insert.setInt(1, _steward_id);
            insert.setInt(2, _driver_id);
            insert.setString(3, formatarg);
            insert.executeUpdate();

            c.commit();
            insert.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void insertStewardTeamUpdateTracker(int _steward_id, int _team_id) {
        try {
            String insertSTVT = "INSERT INTO StewardTeamUpdateTracker(employee_id, employer_id, timestamp) " +
                    "VALUES(?,?,?); ";
            PreparedStatement insert = c.prepareStatement(insertSTVT);

            Date date = new Date();
            Timestamp arg = new java.sql.Timestamp(date.getTime());
            String formatarg = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(arg);

            insert.setInt(1, _steward_id);
            insert.setInt(2, _team_id);
            insert.setString(3, formatarg);
            insert.executeUpdate();

            c.commit();
            insert.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void viewDriverNames() {
        System.out.printf("%-30s\n",
                "Name");
        try {
            String viewDrNames = "SELECT name " +
                    "FROM Driver; ";
            PreparedStatement view = c.prepareStatement(viewDrNames);
            ResultSet DrNameList = view.executeQuery();

            while (DrNameList.next()) {
                String name = DrNameList.getString(1);
                System.out.printf("%-30s\n", name);
            }
            view.close();
            DrNameList.close();

        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void viewTeamNames() {
        System.out.printf("%-35s\n", "Name");
        try {
            String viewTeamNames = "SELECT name " +
                    "FROM Team; ";
            PreparedStatement view = c.prepareStatement(viewTeamNames);
            ResultSet TeamNameList = view.executeQuery();

            while (TeamNameList.next()) {
                String name = TeamNameList.getString(1);
                System.out.printf("%-35s\n", name);
            }

            view.close();
            TeamNameList.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void viewEmployerNames() {
        System.out.printf("%-50s\n", "Name");
        try {
            String viewEmployerNames = "SELECT name " +
                    "FROM Employer WHERE role <> 'f1team'; ";
            PreparedStatement view = c.prepareStatement(viewEmployerNames);
            ResultSet EmplNameList = view.executeQuery();

            while (EmplNameList.next()) {
                String name = EmplNameList.getString(1);
                System.out.printf("%-50s\n", name);
            }

            view.close();
            EmplNameList.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void viewMarshalLocation (int _marshal_id) {
        try {
            String viewLocation = "SELECT tracklocation " +
                    "FROM Marshal WHERE employee_id = ?; ";
            PreparedStatement view = c.prepareStatement(viewLocation);
            view.setInt(1, _marshal_id);
            ResultSet locationSet = view.executeQuery();

            while (locationSet.next()) {
                String location = locationSet.getString(1);
                System.out.printf("%-15s\n", location);
            }

            view.close();
            locationSet.close();
        } catch (Exception e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            } catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }



    public static void main(String args[]) {
        Scanner scan = new Scanner(System.in);
        String input = " ";
        phase3 dbconnection = new phase3();

        dbconnection.openConnection("data.sqlite");

        while (!input.equals("STOP")) {
            System.out.println(
                    "What role are you? [sp]ectator, [employer], [team], [employee], [st]eward, [ma]rshal? Or type \"STOP\" to exit.");
            input = String.valueOf(scan.nextLine());
            switch (input) {
                case "sp":
                    System.out.println("Who are you? (insert name, case sensitive)");
                    String nameofsp = String.valueOf(scan.nextLine());
                    int userId = dbconnection.getSpecID(nameofsp);

                    if (userId < 1) {
                        System.out.println("You're not in the system. Inserting you in the system.");
                        userId = dbconnection.insertSpectator(nameofsp);
                    }

                    System.out.println(
                            "What do you want to do?\n 1. View/Sign up for events\n 2. View Driver Standings\n 3. View team standings\n 4. View "
                                    +
                                    "specific driver\n 5. View specific team\n 6. View race weekend results\n 7. View registered events\n " +
                                    "8. Delete from your registered events\n(Enter 1-8)");
                    int input2 = Integer.parseInt(scan.nextLine());

                    if (input2 == 1) {
                        System.out.println("Viewing Events");
                        dbconnection.printEvents();
                        System.out.println(
                                nameofsp + ", Which event do you want to sign up for? (Insert event ID or -1 if none)");
                        int eventId = Integer.parseInt(scan.nextLine());
                        if (eventId > -1) {
                            System.out.println("Registering");

                            if (userId < 1) {
                                System.out.println("You're not in the system. Inserting you in the system.");
                                userId = dbconnection.insertSpectator(nameofsp);
                                dbconnection.insertSpectatorEvents(userId, eventId);
                            } else {
                                dbconnection.insertSpectatorEvents(userId, eventId);
                            }
                        } else {
                            break;
                        }
                    } else if (input2 == 2) {
                        System.out.println("Viewing Driver Standings");

                        userId = dbconnection.getSpecID(nameofsp);
                        dbconnection.viewDriverStandings();
                        if (userId > -1) {
                            dbconnection.insertSpecDriverViewTracker(userId, 0);
                        }
                    } else if (input2 == 3) {
                        System.out.println("Viewing Team Standings");

                        userId = dbconnection.getSpecID(nameofsp);
                        dbconnection.viewTeamStandings();

                        if (userId > -1) {
                            dbconnection.insertSpecTeamViewTracker(userId, 0);
                        }
                    } else if (input2 == 4) {
                        dbconnection.viewDriverNames();
                        System.out.println("Type out the name of the driver you want to view (case sensitive)");
                        String drivername = String.valueOf(scan.nextLine());

                        userId = dbconnection.getSpecID(nameofsp);
                        int driverId = dbconnection.getDriverID(drivername);

                        if (driverId > -1) {
                            dbconnection.viewDriverStatistics(drivername);
                            dbconnection.insertSpecDriverViewTracker(userId, driverId);
                        } else {
                            System.out.println("Invalid driver name");
                            break;
                        }
                    } else if (input2 == 5) {
                        dbconnection.viewTeamNames();
                        System.out.println("Type out the name of the team you want to view (case sensitive)");
                        String teamname = String.valueOf(scan.nextLine());

                        userId = dbconnection.getSpecID(nameofsp);
                        int teamId = dbconnection.getTeamID(teamname);

                        if (teamId > -1) {
                            dbconnection.viewTeamStatistics(teamname);
                            dbconnection.insertSpecTeamViewTracker(userId, teamId);
                        } else {
                            System.out.println("Invalid team name");
                            break;
                        }
                    } else if (input2 == 6) {
                        userId = dbconnection.getSpecID(nameofsp);
                        dbconnection.viewWeekendResults(userId, input);
                    } else if (input2 == 7) {
                        System.out.println("Viewing your registered events");
                        dbconnection.viewSpecEvents(userId);
                    } else if (input2 == 8) {
                        System.out.println("Viewing your registered events");
                        dbconnection.viewSpecEvents(userId);
                        System.out.println("Which events would you like to unregister for? (Select ID)");
                        int eventId = Integer.parseInt(scan.nextLine());
                        dbconnection.deleteSpecEvents(userId, eventId);
                    } else {
                        System.out.println("Improper operation");
                    }
                    break;

                case "employer":
                    dbconnection.viewEmployerNames();
                    System.out.println("What employer are you representing? (insert name, case sensitive)");
                    String nameofemployer = String.valueOf(scan.nextLine());

                    int employerid = dbconnection.getEmployerIDNoF1Teams(nameofemployer);
                    if (employerid < 0) {
                        System.out.println("Invalid employer");
                    } else {
                        System.out.println(
                                "What do you want to do?\n 1. Create new tasks\n 2. Delete old tasks\n 3. Assign tasks to existing employee\n "
                                        +
                                        "4. Viewing employees\n 5. Creating an event\n 6. View and Delete an Event\n " +
                                        "7. Assign yourself to an event\n 8. View Event Popularity\n(Enter 1-8)");
                        input2 = Integer.parseInt(scan.nextLine());
                        if (input2 == 1) {
                            System.out.println("Describe the task.");
                            String desc = String.valueOf(scan.nextLine());
                            System.out.println("Insert the time. (yyyy-MM-dd HH:mm:ss formatting)");
                            String time = String.valueOf(scan.nextLine());
                            System.out.println(
                                    "Do you want to assign this task to everyone or just one employee? (0 for all/1 for one)");
                            int confirm = Integer.parseInt(scan.nextLine());
                            if (confirm == 0) {
                                System.out.println("Inserting into tasks");
                                dbconnection.createTaskAll(employerid, desc, time);
                            } else if (confirm == 1) {
                                dbconnection.viewEmployees(employerid);
                                System.out.println("Which employee do you want to delegate to this task? (select ID)");
                                int _employee_id = Integer.parseInt(scan.nextLine());
                                dbconnection.createTaskOne(employerid, desc, time, _employee_id);
                                System.out.println("Inserting 1");
                            } else {
                                System.out.println("Improper operation");
                            }
                        } else if (input2 == 2) {
                            dbconnection.viewTasks(employerid);
                            System.out.println("Which task would you like to delete?");
                            int _specfictask = Integer.parseInt(scan.nextLine());
                            dbconnection.deleteTask(employerid, _specfictask);
                            System.out.println("Deleting task");
                            dbconnection.viewTasks(employerid);
                        } else if (input2 == 3) {
                            dbconnection.viewTasks(employerid);
                            System.out.println("Which task would you like to assign someone to? (ID value)");
                            int specfictask = Integer.parseInt(scan.nextLine());
                            dbconnection.viewEmployees(employerid);
                            System.out.println("To who would you like to assign this task to");
                            int employeeid = Integer.parseInt(scan.nextLine());
                            dbconnection.assignTask(employerid, specfictask, employeeid);
                            System.out.println("Assigning task: ");
                            dbconnection.viewTasks(employerid);
                        } else if (input2 == 4) {
                            System.out.println("Viewing employees");
                            dbconnection.viewEmployees(employerid);
                        } else if (input2 == 5) {
                            System.out.println("What is the name of the event?");
                            String name = String.valueOf(scan.nextLine());

                            System.out.println("What is the location of the event?");
                            String location = String.valueOf(scan.nextLine());

                            System.out
                                    .println("What time is the event meant to start? (yyyy-MM-dd HH:mm:ss formatting)");
                            String time = String.valueOf(scan.nextLine());
                            dbconnection.createEvent(employerid, name, location, time);
                            dbconnection.viewEventFromEmployer(employerid);
                        } else if (input2 == 6) {
                            dbconnection.viewEventFromEmployer(employerid);
                            System.out.println("Which event would you like to delete? (Event ID)");
                            int specificevent = Integer.parseInt(scan.nextLine());

                            dbconnection.deleteEvent(employerid, specificevent);
                            System.out.println("Deleting event");
                            dbconnection.viewEventFromEmployer(employerid);
                        } else if (input2 == 7) {
                            dbconnection.viewEvents();
                            System.out.println("Which event would you like to register for? (Event ID) ");
                            int specificevent = Integer.parseInt(scan.nextLine());
                            dbconnection.assignEvent(employerid, specificevent);
                            System.out.println("Assigning event");
                            dbconnection.viewEventFromEmployer(employerid);
                        } else if (input2 == 8){
                            System.out.println("Viewing event popularity");
                            dbconnection.viewEventsPopularity(employerid);
                        }
                        else {
                            System.out.println("Improper operation");
                        }

                    }
                    break;

                case "team":
                    dbconnection.viewTeamNames();
                    System.out.println("What team are you representing? (insert name, case sensitive)");
                    String nameofteam = String.valueOf(scan.nextLine());

                    int teamid = dbconnection.getEmployerID(nameofteam);
                    if (teamid < 0) {
                        System.out.println("Invalid employer");
                    } else {
                        System.out.println(
                                "What do you want to do?\n 1. Create new tasks\n 2. Delete old tasks\n 3. Assign tasks to existing employee\n "
                                        +
                                        "4. View employees\n 5. Access driver results\n 6. Access team results\n 7. Access weekend results\n " +
                                        "8. View your team's standings\n 9. View your drivers' standings\n(Enter 1-9)");
                        input2 = Integer.parseInt(scan.nextLine());
                        if (input2 == 1) {
                            System.out.println("Describe the task.");
                            String desc = String.valueOf(scan.nextLine());
                            System.out.println("Insert the time. (yyyy-MM-dd HH:mm:ss formatting)");
                            String time = String.valueOf(scan.nextLine());
                            System.out.println(
                                    "Do you want to assign this task to everyone or just one employee? (0 for all/1 for one)");
                            int confirm = Integer.parseInt(scan.nextLine());
                            if (confirm == 0) {
                                System.out.println("Inserting into tasks");
                                dbconnection.createTaskAll(teamid, desc, time);
                            } else if (confirm == 1) {
                                dbconnection.viewEmployees(teamid);
                                // dbconnection.createTaskOne(teamid, desc, time);
                                System.out.println("Inserting 1");
                            } else {
                                System.out.println("Improper operation");
                            }

                        } else if (input2 == 2) {
                            dbconnection.viewTasks(teamid);
                            System.out.println("Which task would you like to delete?");
                            int _specfictask = Integer.parseInt(scan.nextLine());
                            dbconnection.deleteTask(teamid, _specfictask);
                            System.out.println("Deleting task");
                            dbconnection.viewTasks(teamid);
                        } else if (input2 == 3) {
                            dbconnection.viewTasks(teamid);
                            System.out.println("Which task would you like to assign someone to? (ID value)");
                            int specfictask = Integer.parseInt(scan.nextLine());
                            dbconnection.viewEmployees(teamid);
                            System.out.println("To who would you like to assign this task to");
                            int employeeid = Integer.parseInt(scan.nextLine());
                            dbconnection.assignTask(teamid, specfictask, employeeid);
                            System.out.println("Assigning task: ");
                            dbconnection.viewTasks(teamid);
                        } else if (input2 == 4) {
                            System.out.println("Viewing employees");
                            dbconnection.viewEmployees(teamid);
                        } else if (input2 == 5) {
                            System.out.println("Viewing driver standings");
                            dbconnection.viewDriverStandings();
                        } else if (input2 == 6) {
                            System.out.println("Viewing team standings");
                            dbconnection.viewTeamStandings();
                        } else if (input2 == 7) {
                            System.out.println("Viewing weekend results");
                            dbconnection.viewWeekendResults(0, input);
                        } else if (input2 == 8) {
                            System.out.println("Viewing your team's statistics");
                            dbconnection.viewTeamStatistics(nameofteam);
                        } else if (input2 == 9) {
                            System.out.println("Viewing your drivers' statistics");
                            dbconnection.viewDriverPairStatistics(nameofteam);
                        } 
                        else {
                            System.out.println("Improper operation");
                        }

                    }
                    break;
                case "employee":
                    System.out.println("Who are you? (insert name, case sensitive)");
                    String nameofempl = String.valueOf(scan.nextLine());
                    System.out.println(
                            "What do you want to do?\n 1. View tasks assigned to them\n 2. Access driver results\n 3. Access team results\n "
                                    +
                                    "4. Access weekend results");
                    input2 = Integer.parseInt(scan.nextLine());
                    if (input2 == 1) {
                        System.out.println("Viewing your tasks");
                        int employeeid = dbconnection.getEmployeeID(nameofempl, input);
                        if (employeeid > -1) {
                            employerid = dbconnection.getEmployerIDFromEmployee(nameofempl);
                            dbconnection.viewIndividualTasks(employeeid, employerid);
                            
                        } else {
                            System.out.println("Invalid employee (wrong name)");
                            break;
                        }
                    }
                    else if (input2 == 2) {
                        System.out.println("Viewing driver standings");
                        dbconnection.viewDriverStandings();
                    }
                    else if (input2 == 3) {
                        System.out.println("Viewing Team standings");
                        dbconnection.viewTeamStandings();
                    }
                    else if (input2 == 4) {
                        System.out.println("Viewing weekend results");
                        dbconnection.viewWeekendResults(0, input);
                    }
                    else{
                        System.out.println("Invalid operation");
                        break;
                    }
                    break;
                case "st":
                    System.out.println("Who are you? (insert name, case sensitive)");
                    String nameofsteward = String.valueOf(scan.nextLine());
                    int employeeid = dbconnection.getEmployeeID(nameofsteward, input);
                    // employeeid = dbconnection.getEmployeeID(nameofsteward, input);
                    if (employeeid > -1) {
                        // employerid = dbconnection.getEmployerIDFromEmployee(nameofemnameofstewardpl);
                        System.out.println(
                            "What do you want to do?\n 1. View Tasks \n 2. Access driver results\n 3. Access team results\n "
                                    +
                                    "4. Access weekend results\n 5. View specific driver results\n 6. View specific team results\n " +
                                    "7. Update points\n 8. Update finishing position\n(Enter 1-8)");
                        input2 = Integer.parseInt(scan.nextLine());
                        if (input2 == 1) {
                            employerid = dbconnection.getEmployerIDFromEmployee(nameofsteward);
                            dbconnection.viewIndividualTasks(employeeid, employerid);
                            System.out.println("Viewing your tasks");
                        }
                        else if (input2 == 2) {
                            System.out.println("Viewing Driver Standings");
                            dbconnection.viewDriverStandings();
                            dbconnection.insertStewardDriverViewTracker(employeeid, 0);
                        }

                        else if (input2 == 3) {
                            System.out.println("Viewing Team Standings");
                            dbconnection.viewTeamStandings();
                            dbconnection.insertStewardTeamViewTracker(employeeid, 0);
                        }

                        else if (input2 == 4) {
                            System.out.println("Viewing weekend results");
                            dbconnection.viewWeekendResults(employeeid, input);
                        }
                        else if (input2 == 5) {
                            dbconnection.viewDriverNames();
                            System.out.println("Type out the name of the driver you want to view (case sensitive)");
                            String drivername = String.valueOf(scan.nextLine());
                            int driverId = dbconnection.getDriverID(drivername);

                            if (driverId > -1) {
                                dbconnection.viewDriverStatistics(drivername);
                                dbconnection.insertStewardDriverViewTracker(employeeid, driverId);
                            } else {
                                System.out.println("Invalid driver name");
                                break;
                            }
                        }
                        else if (input2 == 6) {
                            dbconnection.viewTeamNames();
                            System.out.println("Type out the name of the team you want to view (case sensitive)");
                            String teamname = String.valueOf(scan.nextLine());
                            int teamId = dbconnection.getTeamID(teamname);

                            if (teamId > -1) {
                                dbconnection.viewTeamStatistics(teamname);
                                dbconnection.insertStewardTeamViewTracker(employeeid, teamId);
                            } else {
                                System.out.println("Invalid team name");
                                break;
                            }
                        }
                        else if (input2 == 7) {
                            System.out.println(
                                    "Do you want to remove points from a specific driver, or a specific team? (0 = driver, 1 = team)");
                            int input3 = Integer.parseInt(scan.nextLine());
                            if (input3 == 0) {
                                dbconnection.viewDriverNames();
                                System.out.println(
                                        "Which driver would you like to update?");
                                String drivername = String.valueOf(scan.nextLine());
                                int driverid = dbconnection.getDriverID(drivername);

                                if (driverid > -1) {
                                    dbconnection.viewDriverStatistics(drivername);
                                    dbconnection.insertStewardDriverViewTracker(employeeid, driverid);
                                    System.out.println(
                                            "How many points would you like to subtract from this driver? (Note: this will also "
                                                    +
                                                    "subtract from this team's points total");
                                    int difference = Integer.parseInt(scan.nextLine());

                                    dbconnection.updateDriverStatistics(driverid, difference);
                                    int teamId = dbconnection.getTeamIDFromDriver(driverid);
                                    dbconnection.updateTeamStatistics(teamId, difference);
                                    dbconnection.insertStewardDriverUpdateTracker(employeeid, driverid);
                                    dbconnection.insertStewardTeamUpdateTracker(employeeid, teamId);

                                    System.out.println("");

                                    String teamName = dbconnection.getTeamName(teamId);
                                    dbconnection.viewDriverStatistics(drivername);
                                    dbconnection.viewTeamStatistics(teamName);
                                } else {
                                    System.out.println("Invalid driver name");
                                    break;
                                }
                            } else if (input3 == 1) {
                                dbconnection.viewTeamNames();
                                System.out.println(
                                        "Which team would you like to update?");
                                String teamname = String.valueOf(scan.nextLine());
                                int teamId = dbconnection.getTeamID(teamname);

                                if (teamId > -1) {
                                    dbconnection.viewTeamStatistics(teamname);
                                    dbconnection.insertStewardTeamViewTracker(employeeid, teamId);
                                    System.out.println(
                                            "How many points would you like to subtract from this team? ");
                                    int difference = Integer.parseInt(scan.nextLine());

                                    dbconnection.updateTeamStatistics(teamId, difference);
                                    dbconnection.insertStewardTeamUpdateTracker(employeeid, teamId);

                                    System.out.println("");

                                    String teamName = dbconnection.getTeamName(teamId);
                                    dbconnection.viewTeamStatistics(teamName);
                                } else {
                                    System.out.println("Invalid team name");
                                    break;
                                }
                            }
                        }
                        else if (input2 == 8) {
                            System.out.println(
                                    "Do you want to update overall standings from a specific driver, or a specific team? (0 = driver, 1 = team)");
                            int input3 = Integer.parseInt(scan.nextLine());
                            if (input3 == 0) {
                                dbconnection.viewDriverNames();
                                System.out.println(
                                        "Which driver would you like to update?");
                                String drivername = String.valueOf(scan.nextLine());
                                int driverid = dbconnection.getDriverID(drivername);

                                if (driverid > -1) {
                                    dbconnection.viewDriverStatistics(drivername);
                                    dbconnection.insertStewardDriverViewTracker(employeeid, driverid);
                                    System.out.println("What is their new overall position?");
                                    int position = Integer.parseInt(scan.nextLine());

                                    dbconnection.updateDriverStatisticsPosition(driverid, position);
                                    dbconnection.insertStewardDriverUpdateTracker(employeeid, driverid);

                                    System.out.println("");

                                    dbconnection.viewDriverStatistics(drivername);
                                } else {
                                    System.out.println("Invalid driver name");
                                    break;
                                }
                            } else if (input3 == 1) {
                                dbconnection.viewTeamNames();
                                System.out.println(
                                        "Which team would you like to update?");
                                String teamname = String.valueOf(scan.nextLine());
                                int teamId = dbconnection.getTeamID(teamname);

                                if (teamId > -1) {
                                    dbconnection.viewTeamStatistics(teamname);
                                    dbconnection.insertStewardTeamViewTracker(employeeid, teamId);
                                    System.out.println(
                                            "What is their new overall position?");
                                    int position = Integer.parseInt(scan.nextLine());

                                    dbconnection.updateTeamStatisticsPosition(teamId, position);
                                    dbconnection.insertStewardTeamUpdateTracker(employeeid, teamId);

                                    System.out.println("");

                                    String teamName = dbconnection.getTeamName(teamId);
                                    dbconnection.viewTeamStatistics(teamName);
                                } else {
                                    System.out.println("Invalid team name");
                                    break;
                                }
                            }
                        } else{
                            System.out.println("Improper operation");
                            break;
                        }
                    } else {
                        System.out.println("Invalid steward (wrong name)");
                        break;
                    }
                    break;
                case "ma":
                    System.out.println("Who are you? (insert name, case sensitive)");
                    String nameofmarshal = String.valueOf(scan.nextLine());
                    System.out.println(
                            "What do you want to do?\n 1. View tasks assigned to them\n 2. Access driver results\n 3. Access team results\n "
                                    +
                                    "4. Access weekend results\n 5. Viewing your posted location\n (Select 1-5)");
                    input2 = Integer.parseInt(scan.nextLine());
                    if (input2 == 1) {
                        employeeid = dbconnection.getEmployeeID(nameofmarshal, input);
                        if (employeeid > -1) {
                            employerid = dbconnection.getEmployerIDFromEmployee(nameofmarshal);
                            dbconnection.viewIndividualTasks(employeeid, employerid);
                            System.out.println("Viewing your tasks");
                        } else {
                            System.out.println("Invalid marshal (wrong name)");
                            break;
                        }
                    }
                    else if (input2 == 2) {
                        System.out.println("Viewing driver standings");
                        dbconnection.viewDriverStandings();
                    }
                    else if (input2 == 3) {
                        System.out.println("Viewing Team standings");
                        dbconnection.viewTeamStandings();
                    }
                    else if (input2 == 4) {
                        System.out.println("Viewing weekend results");
                        dbconnection.viewWeekendResults(0, input);
                    }
                    else if (input2 == 5) {
                        employeeid = dbconnection.getEmployeeID(nameofmarshal, input);
                        System.out.println(employeeid);
                        if (employeeid > -1) {
                            System.out.println("Location");
                            dbconnection.viewMarshalLocation(employeeid);
                        } else {
                            System.out.println("Invalid employee (wrong name)");
                            break;
                        }
                    }
                    else{
                        System.out.println("Invalid operation");
                        break;
                    }
                case "STOP":
                    System.out.println("Stopping");
                    break;
                default:
                    System.out.println("Invalid role");
                    break;
            }
        }

        scan.close();
        dbconnection.closeConnection();
    }

}