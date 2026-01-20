-- ------------------------------------------------------------
-- PRIMARY KEY NULL CHECKS
-- ------------------------------------------------------------

-- Members
SELECT member_id
FROM members
WHERE member_id IS NULL;

-- Books
SELECT book_id
FROM books
WHERE book_id IS NULL;

-- Loans
SELECT loan_id
FROM loans
WHERE loan_id IS NULL;

-- ------------------------------------------------------------
-- DUPLICATE PRIMARY KEY CHECKS
-- ------------------------------------------------------------

-- Members
SELECT
    member_id,
    COUNT(*) AS occurrence_count
FROM members
GROUP BY member_id
HAVING COUNT(*) > 1;

-- Books
SELECT
    book_id,
    COUNT(*) AS occurrence_count
FROM books
GROUP BY book_id
HAVING COUNT(*) > 1;

-- Loans
SELECT
    loan_id,
    COUNT(*) AS occurrence_count
FROM loans
GROUP BY loan_id
HAVING COUNT(*) > 1;

-- ------------------------------------------------------------
-- ORPHANED FOREIGN KEY CHECKS
-- ------------------------------------------------------------

-- Loans → Members
SELECT
    l.loan_id,
    l.member_id
FROM loans l
LEFT JOIN members m
    ON l.member_id = m.member_id
WHERE m.member_id IS NULL;

-- Loans → Books
SELECT
    l.loan_id,
    l.book_id
FROM loans l
LEFT JOIN books b
    ON l.book_id = b.book_id
WHERE b.book_id IS NULL;

-- ------------------------------------------------------------
-- REQUIRED FIELD NULL CHECKS
-- ------------------------------------------------------------

-- Loans
SELECT loan_id
FROM loans 
WHERE member_id IS NULL;

SELECT loan_id 
FROM loans 
WHERE book_id IS NULL;

SELECT loan_id 
FROM loans 
WHERE checkout_date IS NULL;

SELECT loan_id 
FROM loans 
WHERE due_date IS NULL;

SELECT loan_id 
FROM loans 
WHERE status IS NULL;

-- Members
SELECT member_id 
FROM members 
WHERE status IS NULL;

SELECT member_id 
FROM members 
WHERE total_fines IS NULL;

-- Books
SELECT book_id
FROM books 
WHERE status IS NULL;

SELECT book_id 
FROM books 
WHERE category IS NULL;
