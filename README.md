# Data Analytics SQL Assessment

This repository contains SQL solutions to a four-question SQL assessment designed to evaluate data querying, aggregation, and business insight skills using a relational database. The assessment is part of my recruitment process to join Cowrywise Data Analyst team, 

## Table of Contents

* [Repository Structure](#repository-structure)
* [Tools Used](#tools-used)
* [Per-Question Explanations](#per-question-explanations)
* [Challenges and Resolutions](#challenges-and-resolutions)

---

## Repository Structure

```
DataAnalytics-Assessment/
│
├── Assessment_Q1.sql
├── Assessment_Q2.sql
├── Assessment_Q3.sql
├── Assessment_Q4.sql
└── README.md
```

---

## Tools Used

* **MySQL Workbench** (Primary SQL interface)
* **MySQL 8+** (RDBMS used)
* `.sql` file used to load and create the database schema

---

## Per-Question Explanations

### Q1: High-Value Customers with Multiple Products

**Objective:** Identify customers with at least one funded savings and one funded investment plan.
**Approach:**

* Filter savings using `is_regular_savings = 1`
* Filter investment using `is_a_fund = 1`
* Joined `users_customuser`, `savings_savingsaccount`, and `plans_plan`
* Grouped by customer and computed counts and total deposit (converted from kobo to Naira)

---

### Q2: Transaction Frequency Analysis

**Objective:** Categorize customers by transaction frequency (High/Medium/Low).
**Approach:**

* Extracted year and month using `DATE_FORMAT(...)`
* Counted monthly transactions per customer
* Averaged the monthly counts and used CASE to assign frequency category
* Grouped and aggregated by frequency group

---

### Q3: Account Inactivity Alert

**Objective:** Identify active accounts (savings/investment) with no inflow in the last 365 days.
**Approach:**

* Used `MAX(transaction_date)` to find the last transaction
* Calculated the inactivity period using `DATEDIFF(CURDATE(), last_transaction_date)`
* Filtered where inactivity\_days > 365
* Combined savings and investment plans using `UNION ALL`

---

### Q4: Customer Lifetime Value (CLV)

**Objective:** Estimate CLV based on tenure and transaction value.
**Approach:**

* Calculated `tenure_months` using `TIMESTAMPDIFF(MONTH, date_joined, CURDATE())`

* Total transactions and average transaction value from `savings_savingsaccount`

* Applied the CLV formula:

  $$
  Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
  $$

* Used `CONCAT(first_name, last_name)` to create readable name output

---

## Challenges and Resolutions

| Challenge                                                                             | Resolution                                                                   |
| --------------------------------------------------                                    | ---------------------------------------------------------------------------- |
| Used jupyter notebook at first but SQLite syntax errors when loading `.sql`           | Switched to MySQL Workbench for smoother compatibility                       |
| `name` column in `users_customuser` was empty                                         | Reconstructed name using `CONCAT(first_name, ' ', last_name)`                |
| `STRFTIME` not supported in MySQL                                                     | Replaced with `DATE_FORMAT(...)` for monthly aggregation                     |
| Syntax error from column alias usage in `GROUP BY`                                    | Reused `DATE_FORMAT(...)` expression directly in `GROUP BY`                  |
| MySQL rejecting `PRAGMA` statement                                                    | Removed SQLite-only commands when switching to MySQL                         |
| Kobo conversion                                                                       | Ensured all currency calculations divided values by 100 for Naira accuracy   |
| Tenure division by zero                                                               | Used `GREATEST(tenure_months, 1)` to prevent division by zero in CLV formula |

---

## Author

Emmanuel Bamidele
Data Analyst
