-- ============================================================
-- 03_fine_validation.sql
-- ============================================================

-- ------------------------------------------------------------
-- FINES MUST ONLY EXIST ON RETURNED LOANS
-- ------------------------------------------------------------
SELECT
    loan_id,
    status,
    fine_amount
FROM loans
WHERE status <> 'RETURNED'
  AND fine_amount > 0;

-- ------------------------------------------------------------
-- RETURNED LOANS MUST HAVE A FINE VALUE (0 OR GREATER)
-- ------------------------------------------------------------
SELECT
    loan_id,
    status,
    fine_amount
FROM loans
WHERE status = 'RETURNED'
  AND fine_amount IS NULL;

-- ------------------------------------------------------------
-- FINE AMOUNTS MUST NOT BE NEGATIVE
-- ------------------------------------------------------------
SELECT
    loan_id,
    fine_amount
FROM loans
WHERE fine_amount < 0;

-- ------------------------------------------------------------
-- MEMBER TOTAL FINES MUST MATCH SUM OF LOAN FINES
-- ------------------------------------------------------------
SELECT
    m.member_id,
    m.total_fines,
    SUM(l.fine_amount) AS calculated_total
FROM members m
JOIN loans l
    ON m.member_id = l.member_id
WHERE l.status = 'RETURNED'
GROUP BY
    m.member_id,
    m.total_fines
HAVING m.total_fines <> SUM(l.fine_amount);

-- ------------------------------------------------------------
-- BLOCKED MEMBERS MUST MEET FINE THRESHOLD
-- ------------------------------------------------------------
SELECT
    member_id,
    status,
    total_fines
FROM members
WHERE status = 'BLOCKED'
  AND total_fines < 50;

-- ------------------------------------------------------------
-- MEMBERS ELIGIBLE FOR BLOCKING BUT STILL ACTIVE
-- ------------------------------------------------------------
SELECT
    member_id,
    status,
    total_fines
FROM members
WHERE status = 'ACTIVE'
  AND total_fines >= 50;
