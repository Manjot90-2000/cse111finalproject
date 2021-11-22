import java.sql.*;
import java.util.Scanner;
import java.util.Date;

import javax.naming.spi.DirStateFactory.Result;

import java.io.FileReader;
import java.io.BufferedReader;
import java.io.File;

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

    private void printEvents(){
        System.out.println("Printing Events");
        System.out.printf("%-10s %-30s %30s %25s\n",
            "Event ID", "Event Name", "Location", "Time");
        try{
            Statement stmt = c.createStatement();
            String printEvents = "SELECT * " +
                "FROM Event ";

            ResultSet events = stmt.executeQuery(printEvents);
            
            while(events.next()){
                String id = events.getString(1);
                String event = events.getString(2);
                String location = events.getString(3);
                String time = events.getString(4);
                System.out.printf("%-10s %-30s %30s %25s\n", id, event, location, time);
            }
            events.close();
            stmt.close();
        }
        catch (Exception e){
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            }
            catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    //NOTE: Consider using a location field in Spectator.
    private int getSpecID(String _name){
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
        }
        catch (Exception e){
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            }
            catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
        return -1;
    }

    private void insertSpectatorEvents(int _spec_id, int _event_id){
        try {
            String insertSpecEv = "INSERT INTO SpectatorEvents(spec_id, event_id) " +
                "VALUES(?,?); ";
            PreparedStatement insert = c.prepareStatement(insertSpecEv);
            insert.setInt(1, _spec_id);
            insert.setInt(2, _event_id);
            insert.executeUpdate();

            c.commit();
            insert.close();
        }
        catch (Exception e){
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            }
            catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void viewDriverStandings(){
        System.out.printf("%-10s %-30s %10s\n",
            "Driver ID", "Name", "Points");
        try {
            String viewWDC = "SELECT driver_id, name, points " +
                "FROM Driver " +
                "ORDER BY points DESC; ";
            PreparedStatement view = c.prepareStatement(viewWDC);
            ResultSet WDC = view.executeQuery();

            while(WDC.next()){
                int id = WDC.getInt(1);
                String name = WDC.getString(2);
                double points = WDC.getDouble(3);
                System.out.printf("%-10s %-30s %10.1f\n", id, name, points);
            }
            view.close();
            WDC.close();
            
        }
        catch (Exception e){
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            }
            catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }
    
    private void viewTeamStandings(){
        System.out.printf("%-10s %-35s %10s\n",
            "Team ID", "Name", "Points");
        try{
            String viewWCC = "SELECT employer_id, name, points " +
            "FROM Team " +
            "ORDER BY points DESC; ";
            PreparedStatement view = c.prepareStatement(viewWCC);
            ResultSet WCC = view.executeQuery();
            
            while(WCC.next()){
                int id = WCC.getInt(1);
                String name = WCC.getString(2);
                double points = WCC.getDouble(3);
                System.out.printf("%-10s %-35s %10.1f\n", id, name, points);
            }

            view.close();
            WCC.close();
        }
        catch (Exception e){
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            }
            catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    private void insertSpecDriverViewTracker(int _spec_id, int _driver_id){
        try{
            String insertSDVT = "INSERT INTO SpecDriverViewTracker(spec_id, driver_id, timestamp) " +
            "VALUES(?,?,?); ";
            PreparedStatement insert = c.prepareStatement(insertSDVT);

            Date date = new Date();
            Timestamp arg = new java.sql.Timestamp(date.getTime());

            insert.setInt(1, _spec_id);
            insert.setInt(2, _driver_id);
            insert.setTimestamp(3, arg);
            insert.executeUpdate();

            c.commit();
            insert.close();
        }
        catch (Exception e){
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            try {
                c.rollback();
            }
            catch (Exception e1) {
                System.err.println(e1.getClass().getName() + ": " + e1.getMessage());
            }
        }
    }

    public static void main(String args[]) {
        Scanner scan = new Scanner(System.in);
        String input;
        phase3 dbconnection = new phase3();

        dbconnection.openConnection("data.sqlite");

        System.out.println("What role are you? [sp]ectator, [employer], [employee], [st]eward, [ma]rshal");
        input = String.valueOf(scan.nextLine());

        switch (input) {
        case "sp":
            System.out.println("Who are you? (insert name, case sensitive)");
            String nameofsp = String.valueOf(scan.nextLine());
            System.out.println(
                    "What do you want to do?\n 1. View/Sign up for events\n 2. View Driver Standings\n 3. View team standings\n(Enter 1-3)");
            int input2 = Integer.parseInt(scan.nextLine());

            if (input2 == 1) {
                //System.out.println("Viewing Events");
                dbconnection.printEvents();
                System.out.println(nameofsp + ", Which event do you want to sign up for? (Insert event ID or -1 if none)");
                int eventId = Integer.parseInt(scan.nextLine());
                if(eventId > -1){
                    System.out.println("Registering");
                    int userId = dbconnection.getSpecID(nameofsp);
                
                    if(userId < 1){
                        System.out.println("You're not in the system. Would you like to be?");
                    }
                    else{
                        dbconnection.insertSpectatorEvents(userId, eventId);
                    }
                }
                else{
                    break;
                }
            }
            else if (input2 == 2) {
                System.out.println("Viewing Driver Standings");

                int userId = dbconnection.getSpecID(nameofsp);
                dbconnection.viewDriverStandings();
                dbconnection.insertSpecDriverViewTracker(userId, 0);
            }
            else if (input2 == 3) {
                System.out.println("Viewing Team Standings");
                dbconnection.viewTeamStandings();
            }
            else {
                System.out.println("Improper operation");
            }

            break;
        case "employer":
            break;
        case "employee":
            break;
        case "st":
            break;
        case "ma":
            break;
        default:
            System.out.println("Invalid role");
            break;
        }
        scan.close();
        dbconnection.closeConnection();
    }

}