-- ============================================================
-- 04_reporting_queries.sql
-- ============================================================

-- ------------------------------------------------------------
-- ACTIVE LOANS PER MEMBER
-- ------------------------------------------------------------
SELECT
    m.member_id,
    COUNT(l.loan_id) AS active_loan_count
FROM members m
LEFT JOIN loans l
    ON m.member_id = l.member_id
   AND l.status = 'ACTIVE'
GROUP BY m.member_id;

-- ------------------------------------------------------------
-- OVERDUE LOANS LIST
-- ------------------------------------------------------------
SELECT
    loan_id,
    member_id,
    book_id,
    checkout_date,
    due_date
FROM loans
WHERE status = 'OVERDUE'
ORDER BY due_date;

-- ------------------------------------------------------------
-- MEMBER LOAN SUMMARY (ACTIVE + OVERDUE)
-- ------------------------------------------------------------
SELECT
    member_id,
    SUM(CASE WHEN status = 'ACTIVE' THEN 1 ELSE 0 END) AS active_loans,
    SUM(CASE WHEN status = 'OVERDUE' THEN 1 ELSE 0 END) AS overdue_loans
FROM loans
GROUP BY member_id;

-- ------------------------------------------------------------
-- MEMBERS ELIGIBLE FOR BLOCKING
-- ------------------------------------------------------------
SELECT
    member_id,
    total_fines
FROM members
WHERE total_fines >= 50
ORDER BY total_fines DESC;

-- ------------------------------------------------------------
-- HIGH-RISK MEMBERS
-- (frequent overdue or high fine totals)
-- ------------------------------------------------------------
SELECT
    m.member_id,
    COUNT(l.loan_id) AS overdue_loan_count,
    m.total_fines
FROM members m
JOIN loans l
    ON m.member_id = l.member_id
WHERE l.status = 'OVERDUE'
GROUP BY
    m.member_id,
    m.total_fines
HAVING COUNT(l.loan_id) >= 2
   OR m.total_fines >= 75
ORDER BY
    overdue_loan_count DESC,
    m.total_fines DESC;
