# 💰 Smart Expense Analyzer & Budget Tracker

A terminal-based Java application where multiple users can register, log in, track their daily expenses by category, and generate a monthly spending report — all stored securely in a MySQL database.

---

## 🎯 What This Project Does

Managing personal finances is hard when there's no record of where money goes. This app solves that:

- **Register** with your name, email, and password
- **Log in** — each user only sees their own data (session-based isolation)
- **Add expenses** with amount, category, and description (auto-saves today's date)
- **View all past expenses** in a clean formatted table
- **Get a monthly report** — category-wise breakdown + total spent this month

---

## 🖥️ How It Looks (Flow)

```
===== Smart Expense Analyzer =====
1. Register
2. Login
3. Exit
Enter choice: 2

Enter email: pranav@gmail.com
Enter password: 1234
✅ Login successful

--- User Menu (Pranav) ---
1. Add Expense
2. View Expenses
3. Monthly Report
4. Logout
Choose: 2

---------------------------------------------------------------------
Date         | Category   | Amount     | Description
---------------------------------------------------------------------
2025-01-15   | Food       |     250.00 | Lunch at canteen
2025-01-14   | Travel     |      80.00 | Bus pass recharge
2025-01-13   | Study      |     500.00 | Books
---------------------------------------------------------------------

Choose: 3

--- Monthly Expense Report ---
Category        | Amount
-------------------------------
Food            | 1200.00
Travel          | 320.00
Study           | 500.00
-------------------------------
Total Spent This Month: 2020.0
```

---

## 🏗️ Database Design

The project uses **3 tables** in MySQL, connected by foreign keys:

```
┌─────────────────────┐        ┌──────────────────────────┐
│       users         │        │        expenses           │
├─────────────────────┤        ├──────────────────────────┤
│ user_id  (PK) 🔑   │──┐     │ expense_id  (PK) 🔑      │
│ name                │  └────▶│ user_id     (FK) 🔗      │
│ email    (UNIQUE)   │        │ amount                    │
│ password            │        │ category                  │
└─────────────────────┘        │ description               │
                               │ expense_date              │
         ┌─────────────────────┤                           │
         │      budget         └──────────────────────────┘
         ├─────────────────────┐
         │ user_id  (PK+FK) 🔗 │
         │ monthly_limit       │
         └─────────────────────┘
```

**Why this design?**
- Each user only accesses their own expenses — enforced by `user_id` foreign key
- `budget` table is ready for a future feature to set monthly spending limits
- `UNIQUE` constraint on email prevents duplicate accounts

---

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| Java (JDK 8+) | Core application language |
| MySQL 8.x | Database for users and expenses |
| JDBC | Java ↔ MySQL connection |
| PreparedStatement | SQL injection prevention |
| Scanner | Terminal input handling |

---

## 📁 Project Structure

```
Smart-Expense-Analyzer/
│
├── Expense.java              ← Main source code (all logic here)
├── expense_tracker.sql       ← Complete database setup script
├── code.txt                  ← Run commands reference
│
└── lib/                      ← Dependency JARs (place all here)
    ├── mysql-connector-j-9.5.0.jar
    ├── bson-4.11.1.jar
    └── slf4j-simple-2.0.9.jar
```

---

## ⚙️ Setup & Installation

### Prerequisites
Make sure these are installed:
- [Java JDK 8 or above](https://www.oracle.com/java/technologies/downloads/)
- [MySQL Server](https://dev.mysql.com/downloads/mysql/)

---

### Step 1 — Set Up the Database

Run the provided SQL file to create the database and all tables in one shot:

```bash
mysql -u root -p < expense_tracker.sql
```

Or open MySQL Workbench / terminal and paste the contents of `expense_tracker.sql`. It will:
- Create the `expense_tracker` database
- Create `users`, `expenses`, and `budget` tables
- Set up all foreign key relationships

---

### Step 2 — Update Your Database Password

Open `Expense.java` and change line 6 to your MySQL password:

```java
static final String DB_PASS = "YOUR_PASSWORD_HERE"; // ← change this
```

---

### Step 3 — Compile & Run

Open terminal/command prompt **inside the project folder** and run:

**Compile:**
```bash
javac -cp ".;*" Expense.java
```

**Run:**
```bash
java -cp ".;*" Expense
```

> On **Mac / Linux**, replace `;` with `:`:
> ```bash
> javac -cp ".:*" Expense.java
> java -cp ".:*" Expense
> ```

---

## ✨ Features

- ✅ Multi-user support — each user has their own account
- ✅ Secure login using email + password with `PreparedStatement`
- ✅ Session handling — user stays logged in until they choose to logout
- ✅ Add expenses with category, description, and auto date
- ✅ View all expenses sorted by most recent date
- ✅ Monthly report — category-wise total + grand total for current month
- ✅ Duplicate email check on registration
- ✅ Clean formatted table output in terminal
- ✅ Budget table ready for future monthly limit feature

---

## 🔐 Security Notes

- All database queries use `PreparedStatement` — this **prevents SQL injection attacks**
- Email uniqueness is enforced at the database level
- Passwords are stored as plain text currently — see Future Improvements below

---

## 🚀 Future Improvements

- [ ] Add password hashing (BCrypt) for secure password storage
- [ ] Activate budget limit feature — alert when monthly spending exceeds limit
- [ ] Add delete / edit expense option
- [ ] Filter expenses by date range or category
- [ ] Export monthly report as CSV or PDF
- [ ] Add a GUI using Java Swing or JavaFX

---

## 👨‍💻 Author

**Pranav Kharage**
- GitHub: [@Pranavkharage](https://github.com/Pranavkharage)
- LinkedIn: [pranav-kharage](https://www.linkedin.com/in/pranav-kharage-824354258/)
