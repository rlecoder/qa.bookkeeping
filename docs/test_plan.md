# 1. Introduction

This test plan outlines the approach, scope, objectives, resources, and deliverables for functional testing of the Library Loans API (v2). Testing focuses on validating API behavior, business logic, and error handling across key endpoints: member summaries, book loans, book returns, and book search.

# 2. Objectives

The objectives of this test effort include:
- Verify that API endpoints function according to the documented contract
- Ensure core business rules (loan limits, blocked status, fines, overdue logic) are enforced correctly
- Validate data integrity and state transitions for members, books, and loans
- Confirm proper error codes and messages for invalid inputs
- Identify defects and inconsistencies
- Produce QA artifacts suitable for real-world portfolio demonstration

# 3. Scope

# Functional testing of the following endpoints:
POST /v2/loans – Checkout book
PATCH /v2/loans/{loan_id}/return – Return book
GET /v2/members/{member_id}/summary
GET /v2/books with query filters (status, category, pagination)

# Covered Activities:
Happy-path validation
Negative/edge case testing
Input validation
Status code verification
Business rule enforcement

# State transitions for:
Member status
Book status
Loan status

# 4. Out of Scope

# 5. Assumptions

# 6. Risks

# 7. Approach

# 8. Deliverables

# 9. Entry/Exit Criteria
