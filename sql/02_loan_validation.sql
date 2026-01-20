-- ============================================================
-- 02_loan_validation.sql
-- ============================================================
-- ------------------------------------------------------------
-- MAX 5 ACTIVE LOANS PER MEMBER
-- ------------------------------------------------------------
SELECT
    member_id,
    COUNT(*) AS active_loan_count
FROM loans
WHERE status = 'ACTIVE'
GROUP BY member_id
HAVING COUNT(*) > 5;

-- ------------------------------------------------------------
-- LOAN STATUS AND RETURN DATE CONSISTENCY
-- ------------------------------------------------------------

-- RETURNED loans must have a return_date
SELECT
    loan_id,
    member_id,
    book_id,
    status,
    return_date
FROM loans
WHERE status = 'RETURNED'
  AND return_date IS NULL;

-- ACTIVE loans must not have a return_date
SELECT
    loan_id,
    member_id,
    book_id,
    status,
    return_date
FROM loans
WHERE status = 'ACTIVE'
  AND return_date IS NOT NULL;

-- OVERDUE loans must not have a return_date
SELECT
    loan_id,
    member_id,
    book_id,
    status,
    return_date
FROM loans
WHERE status = 'OVERDUE'
  AND return_date IS NOT NULL;

-- ------------------------------------------------------------
-- LOAN DATE VALIDATION
-- ------------------------------------------------------------

-- due_date must be on or after checkout_date
SELECT
    loan_id,
    checkout_date,
    due_date
FROM loans
WHERE due_date < checkout_date;

-- return_date cannot be before checkout_date
SELECT
    loan_id,
    checkout_date,
    return_date
FROM loans
WHERE return_date IS NOT NULL
  AND return_date < checkout_date;

-- return_date cannot be in the future
SELECT
    loan_id,
    return_date
FROM loans
WHERE return_date IS NOT NULL
  AND return_date > CURRENT_DATE;

-- ------------------------------------------------------------
-- DUE DATE MUST EQUAL CHECKOUT_DATE + 14 DAYS
-- ------------------------------------------------------------

SELECT
    loan_id,
    checkout_date,
    due_date
FROM loans
WHERE due_date <> (checkout_date + INTERVAL '14 days');

-- ------------------------------------------------------------
-- BOOK STATUS AND LOAN STATUS CONSISTENCY
-- ------------------------------------------------------------

-- AVAILABLE books must not have ACTIVE or OVERDUE loans
SELECT
    b.book_id,
    b.status AS book_status,
    l.loan_id,
    l.status AS loan_status
FROM books b
JOIN loans l
    ON l.book_id = b.book_id
WHERE b.status = 'AVAILABLE'
  AND l.status IN ('ACTIVE', 'OVERDUE');

-- CHECKED_OUT books must have an ACTIVE or OVERDUE loan
SELECT
    b.book_id,
    b.status AS book_status
FROM books b
LEFT JOIN loans l
    ON l.book_id = b.book_id
   AND l.status IN ('ACTIVE', 'OVERDUE')
WHERE b.status = 'CHECKED_OUT'
  AND l.loan_id IS NULL;

-- ------------------------------------------------------------
-- ONLY ONE ACTIVE OR OVERDUE LOAN PER BOOK
-- ------------------------------------------------------------
SELECT
    book_id,
    COUNT(*) AS active_like_loan_count
FROM loans
WHERE status IN ('ACTIVE', 'OVERDUE')
GROUP BY book_id
HAVING COUNT(*) > 1;
