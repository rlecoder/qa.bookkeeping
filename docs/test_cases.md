# Manual Test Cases — QA Bookkeeping (v2)

This document contains manual test cases covering loan and return workflows.

---

## **TC-LOAN-001 — Successful checkout with valid member and book**

### Preconditions
- Member exists with `member_id = 101`
- Member has fewer than 5 active loans
- Book exists with `book_id = 200` and status = AVAILABLE

### Steps
1. Send POST request to `/v2/loans`.
2. Body: { "member_id": 101, "book_id": 200 }
3. Observe response.

### Expected Result
- Status: 201 CREATED
- status = ACTIVE
- loan_id is generated
- correct member_id and book_id returned
- checkout_date correctly set
- due_date = checkout_date + 14 days
- Book status = CHECKED_OUT
- Member active loan count increases by 1

---

## **TC-LOAN-002 — Due date is calculated correctly**

### Preconditions
- Same as TC-LOAN-001

### Steps
1. Make a valid POST call.
2. Verify checkout_date returned.
3. Calculate expected due_date manually.

### Expected Result
- Status: 201 CREATED
- due_date = checkout_date + 14 days
- Date format = YYYY-MM-DD
- No timezone inconsistencies observed

---

## **TC-LOAN-003 — Blocked member cannot checkout**

### Preconditions
- Member total_fines = 75
- Member status = BLOCKED
- Book is AVAILABLE

### Steps
1. Send POST request with blocked member_id.

### Expected Result
- Status: 403 FORBIDDEN
- Error message indicates member is blocked due to unpaid fines
- No loan created
- Book status remains AVAILABLE

---

## **TC-LOAN-004 — Member with maximum loans cannot checkout**

### Preconditions
- Member has 5 ACTIVE loans
- Book is AVAILABLE

### Steps
1. Send POST request using a member_id with 5 active loans.

### Expected Result
- Status: 409 CONFLICT
- Error message indicates maximum active loans reached
- No loan created

---

## **TC-LOAN-005 — Book already checked out**

### Preconditions
- Book status = CHECKED_OUT
- Member is valid and ACTIVE

### Steps
1. Send POST request using this book_id.

### Expected Result
- Status: 409 CONFLICT
- Error message indicates the book is not available
- No new loan record created

---

## **TC-LOAN-006 — Invalid member_id or book_id**

### Preconditions
- N/A (invalid IDs used intentionally)

### Steps
1. Send POST request with invalid member_id and book_id.
   { "member_id": 99999, "book_id": 12345 }

### Expected Result
- Status: 404 NOT FOUND or 400 BAD REQUEST depending on implementation
- Error message indicates invalid or nonexistent ID
- No loan created

---

## **TC-RETURN-001 — Successful on-time return with no fine**

### Preconditions
Loan exists with:
- loan_id = 5001
- member_id = 101
- book_id = 200
- checkout_date = 2026-01-01
- due_date = 2026-01-15
- status = ACTIVE
- return_date is on or before due_date
- Book status = CHECKED_OUT

### Steps
1. Send PATCH request to `/v2/loans/5001/return`.
   { "return_date": "2026-01-10" }
3. Observe returned loan fields.

### Expected Result
- Status: 200 OK
- status = RETURNED
- return_date set correctly
- fine_amount = 0
- Book status = AVAILABLE
- Member total_fines unchanged

---

## **TC-RETURN-002 — Late return with correct fine calculation**

### Preconditions
Loan exists with:
- loan_id = 5002
- checkout_date = 2026-01-01
- due_date = 2026-01-15
- status = ACTIVE
- Member total_fines = 10.00
- Book status = CHECKED_OUT

### Steps
1. Send PATCH request returning book late.
   { "return_date": "2026-01-20" }
3. Calculate overdue days manually (5).
4. Calculate expected fine (5 × 0.50 = 2.50).

### Expected Result
- Status: 200 OK
- status = RETURNED
- fine_amount = 2.50
- member_total_fines = 12.50
- Book status = AVAILABLE

---

## **TC-RETURN-003 — Return causes member to become BLOCKED**

### Preconditions
Loan exists with:
- loan_id = 5003
- due_date = 2026-01-10
- status = ACTIVE

Member details:
- member_id = 102
- total_fines = 49.75
- status = ACTIVE

### Steps
1. Send PATCH return request.
   { "return_date": "2026-01-11" }
2. Verify updated fine and member status.

### Expected Result
- Status: 200 OK
- status = RETURNED
- fine_amount = 0.50
- member_total_fines = 50.25
- Member status = BLOCKED

---

## **TC-RETURN-004 — Returning a loan that is already RETURNED**

### Preconditions
Loan exists with:
- loan_id = 5004
- status = RETURNED
- return_date already set
- Book status = AVAILABLE

### Steps
1. Send PATCH return request again.
   { "return_date": "2026-01-20" }

### Expected Result
- Status: 409 CONFLICT
- Error message indicates loan is already returned
- No changes to return_date
- No changes to fine_amount
- No changes to member fines
- Book status remains AVAILABLE

---

## **TC-RETURN-005 — Invalid/nonexistent loan_id**

### Preconditions
- No loan exists with loan_id = 99999

### Steps
1. Send PATCH request using loan_id 99999.
   { "return_date": "2026-01-10" }

### Expected Result
- Status: 404 NOT FOUND
- Error message indicates loan not found
- No data changes to any member, book, or loan

---

## **TC-RETURN-006 — Return date before checkout date (invalid)**

### Preconditions
Loan exists with:
- loan_id = 5005
- checkout_date = 2026-01-10
- status = ACTIVE

### Steps
1. Send PATCH request using a return_date earlier than checkout_date.
   { "return_date": "2026-01-05" }

### Expected Result
- Status: 400 BAD REQUEST
- Error message indicates invalid return_date
- status remains ACTIVE
- Book status remains CHECKED_OUT

---

## **TC-RETURN-007 — Return date in the future**

### Preconditions
- Loan exists with status = ACTIVE
- Today = 2026-01-10

### Steps
1. Send PATCH request with return_date in the future.
   { "return_date": "2026-02-01" }

### Expected Result
- Status: 400 BAD REQUEST
- Error message indicates return_date cannot be in the future
- status remains ACTIVE
- Book status remains CHECKED_OUT
- No fines applied

---

## **TC-RETURN-008 — Missing return_date defaults to today**

### Preconditions
Loan exists with:
- loan_id = 5006
- status = ACTIVE
- Today = 2026-01-10

### Steps
1. Send PATCH request with empty body.
   { }
3. Observe assigned return_date and fine.

### Expected Result
- Status: 200 OK
- return_date is set to today (2026-01-10)
- fine_amount calculated based on due_date
- status = RETURNED
- Book status = AVAILABLE

---

## TC-MEMBER-001 — Retrieve summary for valid active member

### Preconditions
- Member exists with:
- member_id = 101
- status = ACTIVE
- total_fines = 0
- active_loans_count = 2
- overdue_loans_count = 0

### Steps
1. Send GET request to /v2/members/101/summary.
2. Observe returned fields.

### Expected Result
- Status: 200 OK
- Correct member_id and name returned
- status = ACTIVE
- active_loans_count = 2
- overdue_loans_count = 0
- Loan list includes 2 active loans with correct details

--- 

## TC-MEMBER-002 — Member with zero loans returns correct structure

### Preconditions
- Member exists with:
- member_id = 102
- total_fines = 0
- active_loan_count = 0

### Steps
1. Send GET request to /v2/members/102/summary.

### Expected Result
- Status: 200 OK
- active_loans_count = 0
- overdue_loans_count = 0
- loans list is empty (not null)
- status = ACTIVE

---

## TC-MEMBER-003 — Member with overdue loans shows accurate count

### Preconditions
- Member exists with:
- member_id = 103
- total_fines = 0
- 2 overdue loans
- status = ACTIVE

### Steps
- Send GET request to /v2/members/103/summary.

### Expected Result
- Status: 200 OK
- overdue_loans_count = 2
- active_loans_count correctly reflects number of active loans
- Loans returned have status = OVERDUE and proper due_date

---

## TC-MEMBER-004 — Member with fines above block threshold shows BLOCKED status

### Preconditions
- Member exists with:
- member_id = 104
- total_fines = 60.00
- status = BLOCKED
- active_loans_count may be 0 or more

### Steps
1. Send GET request to /v2/members/104/summary.

### Expected Result
- Status: 200 OK
- status = BLOCKED
- total_fines = 60.00
- Member cannot check out new books (business rule reflected in status)

---

## TC-MEMBER-005 — Invalid member_id returns error

### Preconditions
No member exists with member_id = 99999

### Steps
1. Send GET request to /v2/members/99999/summary.

### Expected Result
- Status: 404 NOT FOUND or 400 BAD REQUEST depending on implementation
- Error message indicates member does not exist

---

## TC-MEMBER-006 — Member exists but has inconsistent loan data

### Preconditions
- Member exists with:
- member_id = 105
- summary says 3 active loans
- backend loan list is missing one (intentional mock inconsistency)

### Steps
1. Send GET request to /v2/members/105/summary.

### Expected Result
- Status: 200 OK
- Detected inconsistency:
- active_loans_count does not match loan list count
- This should be logged as a DEFECT in defect log

---

## C-BOOK-001 — Get all books with no filters

### Preconditions
- Library has multiple books across different categories and statuses (AVAILABLE, CHECKED_OUT, LOST).

### Steps
1. Send GET request to /v2/books with no query parameters.
2. Observe the returned list.

### Expected Result
- Status: 200 OK
- A list of books is returned.
- Each book contains at least: book_id, title, category, status.

---

TC-BOOK-002 — Filter by status = AVAILABLE

### Preconditions
At least one book with status = AVAILABLE.
At least one book with status != AVAILABLE.

### Steps

1. Send GET request to /v2/books?status=AVAILABLE.
2. Observe all returned books.

### Expected Result
- Status: 200 OK
- Every returned book has status = AVAILABLE.
- No books with other statuses are included.

---

## TC-BOOK-003 — Filter by status and category together

### Preconditions
- At least one book with:
- category = FANTASY
- status = AVAILABLE
- Other books exist that are:
- FANTASY but not AVAILABLE, or
- AVAILABLE but not FANTASY.

### Steps
1. Send GET request to /v2/books?status=AVAILABLE&category=FANTASY.
2. Observe the returned list.

### Expected Result
- Status: 200 OK.
- Every returned book has:
- status = AVAILABLE
- category = FANTASY.
- No books outside that combination are included.

---

## TC-BOOK-004 — Basic pagination returns correct number of items

### Preconditions
- At least 25 books exist in the system.

### Steps
1. Send GET request to /v2/books?page=1&page_size=10.
2. Count the number of books returned.

### Expected Result
- Status: 200 OK.
- Exactly 10 books are returned (assuming enough data exists).
- If pagination fields are present, page = 1 and page_size = 10 are correct.

---

## TC-BOOK-005 — Invalid pagination values return an error

### Preconditions
- N/A (testing invalid input handling).

### Steps
1. Send GET request to /v2/books?page=0&page_size=10.
2. Send GET request to /v2/books?page=1&page_size=0.

### Expected Result
- Status: 400 BAD REQUEST (or equivalent validation error) for each invalid request.
- Error message indicates page and page_size must be positive integers.
- No book data is returned.
