# Summary of Testing Activities

This project focuses on manually validating core functionality of a simple Bookkeeping API. The testing effort covers the main user flows related to book loans, returns, member account status, and book lookup features. The goal is to ensure each workflow behaves according to the defined business rules and returns accurate, consistent data.

---

## **Areas Covered**

- Loan checkout process  
- Loan return process  
- Fine calculation rules based on overdue days  
- Member status changes when fines reach the threshold  
- Member summary reporting  
- Book search with filters and pagination  
- Handling of invalid or missing input values  

---

## **Test Documentation Included**

- Test plan outlining scope and approach  
- Test scenarios covering expected behaviors  
- Manual test cases for Loans, Returns, Member Summary, and Book Search  
- Notes prepared for potential defect logging  
- Summary of overall findings  

---

## **Key Behaviors Verified**

- Members must be active and under the loan limit to check out books  
- Books must be available before checkout is allowed  
- Due dates are generated correctly using a 14-day window  
- Overdue returns calculate fines based on daily rate  
- Member accounts move to BLOCKED when fine totals reach the rule threshold  
- Return operations correctly free the book and update loan status  
- Member summary data properly reflects counts for active, overdue, and returned loans  
- Book search filters only return matching results  
- Pagination returns the correct number of items per page  
- Invalid query parameters return appropriate error responses  

---

## **Testing Approach**

The test cases use a mix of standard positive checks, negative checks, and boundary conditions. Validation focuses on:

- HTTP status codes  
- Accuracy of returned fields  
- Correct application of business rules  
- State updates to members, books, and loans  
- Error handling behavior  

---

## **Overall Outcome**

The core functional areas appear logically consistent based on the defined rules. Additional defects will be logged in a separate section if discrepancies are found during execution or when more edge cases are evaluated.
