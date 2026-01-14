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

## Functional testing of the following endpoints:
- POST /v2/loans – Checkout book
- PATCH /v2/loans/{loan_id}/return – Return book
- GET /v2/members/{member_id}/summary
- GET /v2/books with query filters (status, category, pagination)

## Covered Activities:
- Happy-path validation
- Negative/edge case testing
- Input validation
- Status code verification
- Business rule enforcement

## State transitions for:
Member status
Book status
Loan status

# 4. Out of Scope

The following are excluded from this test cycle:
- Non-functional testing (performance, load, security)
- UI testing (no UI exists)
- Database performance or indexing
- Internal service-to-service communication
- Authentication/authorization flows (assumed working)
- Email or notification triggers (not in spec)

# 5. Assumptions

- Dates returned by the API are in ISO 8601 format (YYYY-MM-DD)
- Server timezone is consistent and stable
- Mock API data may not always follow business rules (intentional for defect reporting)
- No authentication tokens are required unless specified
- Loan and fine calculations use simplified, non-configurable rules

# 6. Risks

## Medium Risks:
- Inconsistent mock data may produce false positives
- Date-related logic may vary depending on current date

## Low Risks:
- Unexpected mock server downtime
- Pagination limits not clearly defined

# 7. Approach

Manual testing will be performed using logical validation steps. The approach includes:

## 6.1 Functional Testing
- Verify endpoint functionality against the API contract
- Validate success and error flows

## 6.2 Boundary & Edge Case Testing
Examples:
  - Member with exactly 5 active loans
  - Book with invalid status
  - Return date before checkout date
  - Very large page numbers

## 6.3 Data Relationship Checks
Even without a real DB, the tester will “simulate” backend values to validate state accuracy, such as:
  - Count of active loans
  - Member fines total
  - Book availability transition

## 6.4 Regression Mindset
- Future updates should not break core functions like checkout, availability, or fines.

# 8. Deliverables

You will produce the following artifacts:
- Deliverable	Description
- Test Plan	This document
- Test Scenarios	High-level coverage list by endpoint
- Test Cases	Detailed, step-by-step expected results
- Defect Log	Identified issues with steps + expected vs actual
- Summary Report	Final results and insights

# 9. Entry/Exit Criteria

## Entry Criteria:
- API contract available
- Mock API endpoints reachable
- Test environment accessible

## Exit Criteria:
- All high-priority test cases executed
- Critical defects documented
- Test summary completed
- No open P1 blocking issues
