import java.sql.*;
import java.util.Scanner;

public class Expense {

    // ===== DATABASE CONFIG =====
    static final String DB_URL = "jdbc:mysql://localhost:3306/expense_tracker";
    static final String DB_USER = "root";
    static final String DB_PASS = "PranavKharage"; // CHANGE THIS

    static Scanner sc = new Scanner(System.in);

    // Session variables
    static int loggedInUserId = -1;
    static String loggedInUserName = "";

    // ===== JDBC CONNECTION =====
    static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }

    // ===== MAIN =====
    public static void main(String[] args) {

        while (true) {
            System.out.println("\n===== Smart Expense Analyzer =====");
            System.out.println("1. Register");
            System.out.println("2. Login");
            System.out.println("3. Exit");
            System.out.print("Enter choice: ");

            int choice = sc.nextInt();
            sc.nextLine();

            switch (choice) {
                case 1 -> registerUser();
                case 2 -> loginUser();
                case 3 -> {
                    System.out.println("Thank you!");
                    System.exit(0);
                }
                default -> System.out.println("Invalid option");
            }
        }
    }

    // ===== REGISTER =====
    static void registerUser() {
        try (Connection con = getConnection()) {

            System.out.print("Enter name: ");
            String name = sc.nextLine();

            System.out.print("Enter email: ");
            String email = sc.nextLine();

            System.out.print("Enter password: ");
            String password = sc.nextLine();

            String sql = "INSERT INTO users (name, email, password) VALUES (?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);

            ps.executeUpdate();
            System.out.println("✅ Registration successful");

        } catch (SQLIntegrityConstraintViolationException e) {
            System.out.println("❌ Email already exists");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ===== LOGIN =====
    static void loginUser() {
        try (Connection con = getConnection()) {

            System.out.print("Enter email: ");
            String email = sc.nextLine();

            System.out.print("Enter password: ");
            String password = sc.nextLine();

            String sql = "SELECT user_id, name FROM users WHERE email=? AND password=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                loggedInUserId = rs.getInt("user_id");
                loggedInUserName = rs.getString("name");
                System.out.println("✅ Login successful");
                userMenu();
            } else {
                System.out.println("❌ Invalid credentials");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ===== USER MENU =====
    static void userMenu() {
        while (loggedInUserId != -1) {
            System.out.println("\n--- User Menu (" + loggedInUserName + ") ---");
            System.out.println("1. Add Expense");
            System.out.println("2. View Expenses");
            System.out.println("3. Monthly Report");
            System.out.println("4. Logout");
            System.out.print("Choose: ");

            int choice = sc.nextInt();
            sc.nextLine();

            switch (choice) {
                case 1 -> addExpense();
                case 2 -> viewExpenses();
                case 3 -> monthlyReport();
                case 4 -> logout();
                default -> System.out.println("Invalid option");
            }
        }
    }

    // ===== ADD EXPENSE =====
    static void addExpense() {
        try (Connection con = getConnection()) {

            System.out.print("Enter amount: ");
            double amount = sc.nextDouble();
            sc.nextLine();

            System.out.print("Enter category: ");
            String category = sc.nextLine();

            System.out.print("Enter description: ");
            String description = sc.nextLine();

            String sql = """
                INSERT INTO expenses (user_id, amount, category, description, expense_date)
                VALUES (?, ?, ?, ?, CURDATE())
            """;

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, loggedInUserId);
            ps.setDouble(2, amount);
            ps.setString(3, category);
            ps.setString(4, description);
            ps.executeUpdate();

            System.out.println("✅ Expense added successfully");
            

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ===== VIEW EXPENSES =====
    static void viewExpenses() {
        try (Connection con = getConnection()) {

            String sql = """
                SELECT expense_date, category, amount, description
                FROM expenses
                WHERE user_id=?
                ORDER BY expense_date DESC
            """;

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, loggedInUserId);

            ResultSet rs = ps.executeQuery();

            System.out.println("\n---------------------------------------------------------------------");
            System.out.printf("%-12s | %-10s | %-10s | %-25s%n",
                    "Date", "Category", "Amount", "Description");
            System.out.println("---------------------------------------------------------------------");

            while (rs.next()) {
                System.out.printf("%-12s | %-10s | %-10.2f | %-25s%n",
                        rs.getDate("expense_date"),
                        rs.getString("category"),
                        rs.getDouble("amount"),
                        rs.getString("description"));
            }

            System.out.println("---------------------------------------------------------------------");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ===== MONTHLY REPORT =====
    static void monthlyReport() {
        try (Connection con = getConnection()) {

            String sql = """
                SELECT category, SUM(amount) AS total
                FROM expenses
                WHERE user_id=?
                AND MONTH(expense_date)=MONTH(CURDATE())
                AND YEAR(expense_date)=YEAR(CURDATE())
                GROUP BY category
            """;

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, loggedInUserId);

            ResultSet rs = ps.executeQuery();

            double grandTotal = 0;

            System.out.println("\n--- Monthly Expense Report ---");
            System.out.printf("%-15s | %-10s%n", "Category", "Amount");
            System.out.println("-------------------------------");

            while (rs.next()) {
                double amt = rs.getDouble("total");
                grandTotal += amt;
                System.out.printf("%-15s | %.2f%n",
                        rs.getString("category"), amt);
            }

            System.out.println("-------------------------------");
            System.out.println("Total Spent This Month: " + grandTotal);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ===== LOGOUT =====
    static void logout() {
        loggedInUserId = -1;
        loggedInUserName = "";
        System.out.println("🔒 Logged out successfully");
    }
}
