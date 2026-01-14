Version: 1.0

This section identifies the high-level test scenarios grouped by endpoint. These scenarios serve as the foundation for detailed test cases.

# 1. POST /v2/loans — Checkout Book

## Happy Path

SC-LOAN-001: Valid member with fewer than 5 active loans successfully checks out an available book
SC-LOAN-002: Member checks out a book and due_date is calculated correctly (checkout_date + 14 days)
SC-LOAN-003: Book status updates from AVAILABLE → CHECKED_OUT after successful checkout
SC-LOAN-004: Active loan count increases by 1 after checkout

## Negative / Edge Cases

SC-LOAN-005: Blocked member attempts checkout (expect 403)
SC-LOAN-006: Member with 5 active loans attempts a 6th (expect 409)
SC-LOAN-007: Book is already CHECKED_OUT (expect 409)
SC-LOAN-008: Book marked LOST cannot be checked out
SC-LOAN-009: Invalid or nonexistent member_id (expect 404/400)
SC-LOAN-010: Invalid or nonexistent book_id (expect 404/400)
SC-LOAN-011: Missing required fields in request body

# 2. PATCH /v2/loans/{loan_id}/return — Return Book

## Happy Path

SC-RETURN-001: Valid return updates loan status from ACTIVE → RETURNED
SC-RETURN-002: Fine calculated correctly when book is returned late
SC-RETURN-003: Member total_fines updated correctly
SC-RETURN-004: Book status updates from CHECKED_OUT → AVAILABLE on return

## Negative / Edge Cases

SC-RETURN-005: Returning a book that is already RETURNED
SC-RETURN-006: Invalid loan_id (expect 404)
SC-RETURN-007: Return date before checkout_date (invalid)
SC-RETURN-008: Return date in the future (depends on rules)

# 3. GET /v2/members/{member_id}/summary

## Happy Path

SC-MEMBER-001: Retrieve summary for an active member
SC-MEMBER-002: Member with zero loans returns correct counts (active=0, overdue=0)
SC-MEMBER-003: Member with overdue loans shows accurate overdue count
SC-MEMBER-004: Member with >$50 fines shows status as BLOCKED

## Negative / Edge Cases

SC-MEMBER-005: Invalid member_id (expect 404/400)
SC-MEMBER-006: Member exists but has corrupt/inconsistent data (defect discovery scenario)

# 4. GET /v2/books — Filtering & Pagination

## Happy Path

SC-BOOKS-001: Retrieve all books with no filters
SC-BOOKS-002: Filter by status (AVAILABLE)
SC-BOOKS-003: Filter by category (SCIFI, FANTASY, MYSTERY, etc.)
SC-BOOKS-004: Apply both filters together
SC-BOOKS-005: Pagination returns correct page + page_size results
SC-BOOKS-006: Verify total_count matches expected dataset

## Negative / Edge Cases

SC-BOOKS-007: Invalid status filter value
SC-BOOKS-008: Invalid category filter value
SC-BOOKS-009: page < 1 or page_size < 1
SC-BOOKS-010: page beyond total_count returns empty list

SC-BOOKS-011: Extremely large page_size (stress parameter test)
