SQL Validation — Duplicate Primary Key Checks

Members — Duplicate member_id
  
SELECT
    member_id,
    COUNT(*) AS occurrence_count
FROM members
GROUP BY member_id
HAVING COUNT(*) > 1;

Books — Duplicate book_id
  
SELECT
    book_id,
    COUNT(*) AS occurrence_count
FROM books
GROUP BY book_id
HAVING COUNT(*) > 1;

Loans — Duplicate loan_id
  
SELECT
    loan_id,
    COUNT(*) AS occurrence_count
FROM loans
GROUP BY loan_id
HAVING COUNT(*) > 1;
