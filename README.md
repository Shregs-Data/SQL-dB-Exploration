# -Data & Analytics-

##  Question 1: Funded Savings & Investment Clients

Approaching this question was a bit tricky, so I broke it down into manageable parts using **Common Table Expressions (CTEs)**. The steps included:

1. **Aggregating Savings data per user**
2. **Aggregating Investment data per user**
3. **Performing a final join** with the `users_customuser` table
4. **Adding a filter clause** to select only users with at least:
   - One **funded savings plan**
   - One **funded investment plan**
5. **Sorting the results** by total deposits in **descending order**


##  Question 2: Transaction Frequency Analysis 

###  Steps Taken

1. **Calculated Total Monthly Transactions per clients** 
2. **Calculated the Average Monthly Transactions per clients**  
3. **Classification of Customers by Frequency**  
   - Used their average monthly transactions to classify users into:
     - **High Frequency** (≥ 10 transactions/month)
     - **Medium Frequency** (3–9 transactions/month)
     - **Low Frequency** (≤ 2 transactions/month)
     **This was done with a Case when Statement
4. **Aggregated Final Results**  
   - A Count of the number of customers in each frequency category.
   - The average transaction frequency for each group.
   - And the results was sorted by the customer count.


##  Question 3: Account Inactivity Alert for over a Year

###  Steps Taken
Approaching this question was tricky. But here is the step by step process taken.
1. **Select only the latest Transactions per user for savings**  
   - Identified the most recent transaction date for each savings account owner.
   - Type (savings or investment) in the savings CTE is assumed to be only savings because `is_regular_savings` and `is_a_fund` does not exist in the `savings_savingsaccount` Table

2. **Select only the latest transaction per user for Investments**  
   - Identified the most recent transaction date for each investment account owner.
   - Determine the type of account based on flags (`is_a_fund` or `is_regular_savings`).
   - Calculated inactivity days similarly.

3. **Combined Savings and Investment Data Using a Union**  
   - The inactivity information for both account types was merged into a single dataset.

4. **Filtered for Accounts Inactive for More Than One Year**  
   - Selected ONLY the accounts where inactivity exceeds 365 days.
   - Limited the results to ONLY savings or investment account types.
   - Got the result


##  Question 4: Customer Lifetime Value (CLV) Estimation

###  Steps Taken

1. **Selected Owner Information and Account Tenure in a CTE**  
   - Selected the ID and name of client and calculated how long each account has been active in months (`account_tenure_months`) by comparing the signup date with the current date.

2. **Calculated Total Transaction Volume per Customer in another CTE**  
   - Summed all confirmed transaction amounts from the savings account table grouped by owner id.

3. **Joined CTE 1 and CTE 2 i.e Owners and Transaction Summary**  
   - Combined the owners/account tenure data (CTE 1) with total transaction volume (CTE 2) for each customer.

4. **Calculated Estimated CLV**  
   - Estimated Customer Lifetime Value using the formula:  
      ##### Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction) 
   - Used `NULLIF` to avoid division by zero when account tenure is zero.
   - Rounded the CLV value to 2 decimal places.

5. **Sorted the results with the calculated CLV in Descending Order**  
  

