# T-SQL Architecture Practicum: Stored Procedures, Advanced Triggers & Functions

Welcome to my SQL portfolio repository! This project serves as a concentrated, high-quality showcase of my database development, automation, and integrity management skills using **T-SQL (Microsoft SQL Server)**.

As a Ph.D. in Physics and Mathematics, I approach database scripting with structural completeness, rigorous logical validation, and strict data type mapping. This repository demonstrates my capacity to implement complex backend server-side logic and calculate business metrics for production-ready environments (LMS and CRM systems).

## 🛠️ Advanced Database Concepts Covered
*   **Stored Procedures (`CREATE PROCEDURE`):** Dynamic search logic using text patterns (`LIKE`), data mutations (`UPDATE`, `DELETE`), and modular workflows with input/output parameters (`OUTPUT`).
*   **Database Triggers (`INSTEAD OF` / `AFTER`):** Enforcing strict transactional business rules, human resource capacity tracking, revenue automation, and custom error trapping via `ROLLBACK TRANSACTION` and `RAISERROR`.
*   **User-Defined Functions (UDF):** High-precision financial scale arithmetic mapping (`DECIMAL`), table-valued functions utilizing calendar metrics (`GETDATE()`, `DATEPART()`), and structural analytical data generation.

---

## 📂 Repository Structure & Practical Case Studies

### 1. `tsql_stored_procedures.sql` — LMS / University Database Management
This file contains 10 production-ready stored procedures simulating data automation inside a Learning Management System:
*   **Dynamic Academic Search & Updates:** Querying and dynamically updating credit weights based on string wildcards.
*   **Advanced Metrics via Output Parameters:** Procedures that calculate student density per course (`COUNT`), evaluate assignment pipelines, and extract real-time Grade Point Averages (`AVG`) directly into output variables.
*   **Corporate System Rules:** Computing employment duration deltas (`DATEDIFF`) to automate scheduled payroll adjustments (`Salary * 1.15`).
*   **Statistical Outlier Mining:** Using `TOP 1` filters to extract descriptive records (oldest courses, maximum credit weights) via server memory.

### 2. `tsql_advanced_triggers.sql` — CRM & Corporate System Integration
This script demonstrates complex server-side constraints and automated logging mechanisms:
*   **Data Protection Constraints:** Dual-approach architecture (`INSTEAD OF` and `AFTER` triggers) preventing deletion of registered entities.
*   **Real-time Revenue Automation:** Dynamic background modifications updating customer loyalty status (`DiscountPercent = 15%`) the exact moment purchase volumes cross a commercial threshold (>50,000).
*   **Data Pipelines & Archiving:** An event trigger capturing firing logs from the `Employees` table and seamlessly streaming data into a secure historical database sink (`EmployeesArchive`) with real-time timestamps.
*   **Operational Budget Control:** Enforcing head-count thresholds (e.g., maximum 7 employees per specific role) to prevent over-budgeting.

### 3. `tsql_user_defined_functions.sql` — Structural Analytics
Encapsulating granular data transformations and metrics computation:
*   **Scalar Financial Logic:** Calculating accurate decimal balances and high-precision currency exchange functions.
*   **Multi-Statement Statistics:** Generating multi-variable reports (`MAX`, `MIN`, `AVG`) within a single database call.
*   **Relational Catalog Filters:** Connecting inventory mapping (`Products`), categories, and suppliers using multi-table `JOIN` queries.

---

## 👩‍💻 Let's Connect!
I specialize in bridging the gap between rigorous mathematical logic and robust relational database structures. If you are a recruiter or a team lead looking for a detail-oriented Data Analyst with high T-SQL literacy, let's get in touch:
*   **LinkedIn:**[linkedin.com/in/valentyna-matskevych-07389587](https://www.linkedin.com/in/valentyna-matskevych-07389587)

*   **Email:** matskevych.vt@gmail.com
