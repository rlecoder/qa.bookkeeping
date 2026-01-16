# Known Limitations

The current version of the Bookkeeping API and testing documentation has several limitations that should be considered when reviewing functionality and test coverage. These limitations may impact how the system behaves in edge cases or how fully certain workflows are represented.

---

## Functional Limitations

- Fines are only calculated at the time of return and do not accumulate daily.  
- No automated system exists for notifying users of overdue items.  
- Member blocking is based solely on total fines, not number of overdue items.  
- There is no support for book reservations or waitlists.  
- Loan extensions or renewals are not implemented.  
- Books cannot have multiple copies with separate availability statuses.  

---

## API Limitations

- Error messages and error codes may not be fully standardized across endpoints.  
- Validation rules for query parameters may not cover all possible invalid inputs.  
- Book search does not support partial matching or keyword search.  
- Pagination behavior may vary depending on implementation or dataset size.  
- Some endpoints do not return extended details (e.g., full loan history).  

---

## Data Limitations

- Sample data does not include large datasets needed for performance or stress testing.  
- Limited variety in book categories and statuses may reduce edge-case coverage.  
- No real-time updates or background processes exist for simulating real library operations.  

---

## Testing Limitations

- Manual testing only; no automated test suite implemented yet.  
- Limited negative testing for concurrency or simultaneous operations.  
- No security or authentication testing included.  
- No load, stress, or endurance tests performed.  
- Some test cases assume ideal API responses without handling network issues.  
