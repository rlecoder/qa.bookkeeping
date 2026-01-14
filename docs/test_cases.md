# Manual Test Cases - QA Bookkeeping (v1)

This document contains test cases X to X.

---

## TC-LOAN-001 — Successful checkout with valid member and book

Preconditions:
Member exists with member_id = 101
Member has less than 5 active loans
Book exists with book_id = 200 and status = AVAILABLE

Steps:

Send POST request to /v2/loans
Body:

{ "member_id": 101, "book_id": 200 }

Observe response

Expected Result:
Status code: 201 CREATED
Response contains:
loan_id generated
correct member_id and book_id
correct checkout_date
correct due_date = checkout_date + 14 days
status = ACTIVE
Book status changes to CHECKED_OUT
Member active loan count increases b

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

Send POST /v2/loans with blocked member

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

Send POST with member_id = user with 5 loans

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

Send POST with this book_id

Expected Result:
Status: 409 Conflict
Error message: "Book is not available."
System should NOT create a new loan record

---

## TC-LOAN-006 — Invalid member_id or book_id

Preconditions:
N/A (using invalid IDs)

Steps:

S## end POST with:
{ "member_id": 99999, "book_id": 12345 }

Expected Result:
Status: 404 Not Found OR 400 Bad Request depending on rules
Response message indicates invalid or nonexistent ID

No loan created
