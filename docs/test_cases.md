# Manual Test Cases - QA Bookkeeping (v2)

This document contains test cases X to X.

---

## TC-LOAN-001 — Successful checkout with valid member and book

Preconditions:
Member exists with member_id = 101
Member has less than 5 active loans
Book exists with book_id = 200 and status = AVAILABLE

Steps:

1. Send POST request to /v2/loans

Body:

{ "member_id": 101, "book_id": 200 }

2. Observe response

Expected Result:
Status code: 201 CREATED
Response contains:
loan_id generated
correct member_id and book_id
correct checkout_date
correct due_date = checkout_date + 14 days
status = ACTIVE
Book status changes to CHECKED_OUT
Member active loan count increases by

---

## TC-LOAN-002 — Due date is calculated correctly

Preconditions:
Same as TC-LOAN-001

Steps:

Make valid POST call
Check the checkout_date returned
Manually calculate expected due_date

Expected Result:

due_date returned = checkout_date + 14 days
Date format is YYYY-MM-DD
No timezone inconsistency

---

## TC-LOAN-003 — Blocked member cannot checkout

Preconditions:
Member exists with total_fines = 75
Member status = BLOCKED
Book is AVAILABLE

Steps:

1. Send POST /v2/loans with blocked member

Expected Result:
Status: 403 Forbidden
Error message: "Member is blocked due to unpaid fines."
No loan created
Book status remains AVAILABLE

---

## TC-LOAN-004 — Member with maximum loans cannot checkout

Preconditions:
Member already has 5 ACTIVE loans
Book is AVAILABLE

Steps:

1. Send POST with member_id = user with 5 loans

Expected Result:
Status: 409 Conflict
Error message: "Member has reached maximum active loans."
No loan created

---

## TC-LOAN-005 — Book already checked out

Preconditions:
Book has status = CHECKED_OUT
Member is valid and ACTIVE

Steps:

1. Send POST with this book_id

Expected Result:
Status: 409 Conflict
Error message: "Book is not available."
System should NOT create a new loan record

---

## TC-LOAN-006 — Invalid member_id or book_id

Preconditions:
N/A (using invalid IDs)

Steps:

1. S## end POST with:
{ "member_id": 99999, "book_id": 12345 }

Expected Result:
Status: 404 Not Found OR 400 Bad Request depending on rules
Response message indicates invalid or nonexistent ID
No loan created

---

## TC-RETURN-001 — Successful on-time return with no fine

Preconditions:

Loan exists with:
loan_id = 5001
member_id = 101
book_id = 200
checkout_date = 2026-01-01
due_date = 2026-01-15
status = ACTIVE
Current date and chosen return_date are on or before 2026-01-15
Book status = CHECKED_OUT

Steps:

1. Send PATCH request to /v2/loans/5001/return with body:

{ "return_date": "2026-01-10" }

2. Observe response body and loan fields.

Expected Result:
Status code: 200 OK
Response body:
loan_id = 5001
status = "RETURNED"
return_date = "2026-01-10"
fine_amount = 0
Book status in response (or subsequent check) = AVAILABLE
Member total_fines unchanged.

## TC-RETURN-002 — Late return with correct fine calculation

Preconditions:

Loan exists with:
loan_id = 5002
checkout_date = 2026-01-01
due_date = 2026-01-15
status = ACTIVE
Member currently has total_fines = 10.00
Book status = CHECKED_OUT

Steps:

1. Send PATCH /v2/loans/5002/return:

{ "return_date": "2026-01-20" }

2. Calculate days overdue manually:

Overdue days = 5 (Jan 16–20)
Expected fine = 5 × 0.50 = 2.50
Check fine, member fines, and statuses in response.

Expected Result:
Status code: 200 OK
status = "RETURNED"
fine_amount = 2.50
member_total_fines = 12.50 (10.00 + 2.50)
Book status becomes AVAILABLE.

---

## TC-RETURN-003 — Return that causes member to become BLOCKED

Preconditions:

Loan exists with:
loan_id = 5003
due_date = 2026-01-10
status = ACTIVE

Member:
member_id = 102
total_fines = 49.50
status = ACTIVE
Return will generate fine ≥ 0.50
(e.g., 1 day overdue).

Steps:

1. Send PATCH /v2/loans/5003/return:

{ "return_date": "2026-01-11" }

2. Verify fine and member status.

Expected Result:
Status code: 200 OK
fine_amount = 0.50
member_total_fines = 50.00 (or slightly above, depending on rate)
member = 'BLOCKED'

---

## TC-RETURN-004 — Returning a loan that is already RETURNED

Preconditions:

Loan exists with:
loan_id = 5004
status = "RETURNED"
return_date already set
Book status = AVAILABLE

Steps:

1. Send PATCH /v2/loans/5004/return:

{ "return_date": "2026-01-20" }

Expected Result:
Status code: 409 Conflict
Error message indicates loan is already returned (e.g., "Loan has already been returned.")
No changes to existing return_date, fine_amount, or member fines.
Book status remains unchanged (AVAILABLE).

## TC-RETURN-005 — Invalid/nonexistent loan_id

Preconditions:
No loan exists with loan_id = 99999

Steps:

1. Send PATCH /v2/loans/99999/return:

{ "return_date": "2026-01-10" }

Expected Result:
Status code: 404 Not Found
Error message indicates loan not found.
No data changes to any member/book/loan.

---

## TC-RETURN-006 — Return date before checkout date (invalid)

Preconditions:
Loan exists:
loan_id = 5005
checkout_date = "2026-01-10"
status = ACTIVE

Steps:

1. Send PATCH /v2/loans/5005/return:

{ "return_date": "2026-01-05" }

Expected Result:
Status code: 400 Bad Request
Error message indicating invalid return date (before checkout date).
Loan stays ACTIVE, return_date remains null.
Book stays CHECKED_OUT.

---

## TC-RETURN-007 — Return date in the future

For this project, we’ll define the rule:
System must reject a return_date that is in the future relative to server “today”.

Preconditions:
Loan exists with status = ACTIVE
Today = 2026-01-10 (for example)

Steps:

1.Send PATCH with:

{ "return_date": "2026-02-01" }

Expected Result:
Status code: 400 Bad Request
Error message something like "Return date cannot be in the future."
Loan remains ACTIVE
Book remains CHECKED_OUT
No fines applied.

---

## TC-RETURN-008 — Missing return_date in request body (default to today)

Still some design choices to make will update later.

Preconditions:
Loan exists with:
loan_id = 5006
status = ACTIVE
Today = 2026-01-10

Steps:

1. Send PATCH /v2/loans/5006/return with empty body:

{ }

2. Observe response return_date and fine.

Expected Result:
Status code: 200 OK
return_date set to today (2026-01-10)
Fine calculated based on today vs due_date
Loan status = RETURNED
Book status = AVAILABLE
