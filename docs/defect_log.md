# Defect Log — Bookkeeping API (v2)

This document lists confirmed defects found during manual API testing and SQL validation.  
Mock server limitations are not logged as defects.

---

## DEFECT-001 — Member summary count does not match loan list

**Endpoint:**  
GET /v2/members/{member_id}/summary

**Severity:** Medium  
**Status:** Open

**Description:**  
`active_loans_count` does not match the number of loans returned in the loan list.

**Expected:**  
Loan count matches number of loan records returned.

**Actual:**  
Summary shows 3 active loans, but only 2 loans appear in the list.

---

## DEFECT-002 — Returned loan status not updated

**Endpoint:**  
PATCH /v2/loans/{loan_id}/return

**Severity:** High  
**Status:** Open

**Description:**  
After returning a loan, the status remains `ACTIVE` instead of changing to `RETURNED`.

**Expected:**  
Loan status updates to `RETURNED`.

**Actual:**  
Loan remains `ACTIVE` after return.

---

## DEFECT-003 — Book status not updated after return

**Endpoint:**  
PATCH /v2/loans/{loan_id}/return

**Severity:** High  
**Status:** Open

**Description:**  
Book remains `CHECKED_OUT` after the associated loan is returned.

**Expected:**  
Book status updates to `AVAILABLE`.

**Actual:**  
Book status remains `CHECKED_OUT`.

---

## DEFECT-004 — Pagination count inconsistent with page size

**Endpoint:**  
GET /v2/books?page=1&page_size=10

**Severity:** Low  
**Status:** Open

**Description:**  
Number of books returned does not consistently match the requested page size.

**Expected:**  
Returned book count matches `page_size` when enough data exists.

**Actual:**  
Returned count differs from expected pagination values.

---

## Notes

- Only confirmed defects are listed.
- Intentional mock data inconsistencies are documented as defects when they affect API correctness.
- SQL validation checks did not reveal additional backend integrity issues.


