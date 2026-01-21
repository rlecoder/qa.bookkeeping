# SQL Validation

This folder contains SQL queries used to validate backend data for the Bookkeeping API QA project.

All queries are **read-only** and are intended for data verification only.  
No schema changes or data modifications are performed.

---

## Assumed Tables

The queries are written based on the following table structure inferred from API behavior.

### members
- `member_id` (primary key)
- `status`
- `total_fines`

### books
- `book_id` (primary key)
- `status`
- `category`

### loans
- `loan_id` (primary key)
- `member_id` (foreign key → members)
- `book_id` (foreign key → books)
- `checkout_date`
- `due_date`
- `return_date`
- `status`
- `fine_amount`

---

## File Overview

### `01_integrity_checks.sql`

Basic data integrity checks, including:

- null primary key values  
- duplicate primary keys  
- orphaned foreign key records  
- required non-null fields  

These checks confirm the database structure is consistent before validating business rules.

---

### `02_loan_validation.sql`

Loan-related validation queries, including:

- maximum of 5 active loans per member  
- loan status and return date consistency  
- invalid date combinations  
- book status matching loan status  
- multiple active loans for the same book  

---

### `03_fine_validation.sql`

Fine-related validation queries, including:

- fines applied only on returned loans  
- returned loans missing fine values  
- negative fine amounts  
- member total fines matching loan fines  
- correct blocking status based on fine thresholds  

---

### `04_reporting_queries.sql`

Reporting-style queries used to review backend data and cross-check API responses, such as:

- active loans per member  
- overdue loan lists  
- member loan summaries  
- members eligible for blocking  
- high-risk members with repeated overdue behavior  

---

## Expected Results

Most validation queries are expected to return:

```text
0 rows

