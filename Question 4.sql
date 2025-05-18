-- Step 1: Select the owners id, their name and their account tenure (How long the account has been in operation) from the users table
with owners as ( 
  select 
    id,
    concat(first_name, ' ', last_name) as name,
    timestampdiff(month, date_joined, now()) as account_tenure_months
  from users_customuser
),
-- step 2 : Select the owners id and their total transaction volume from the savings table
transaction_summary as (
  select 
    owner_id,
    sum(confirmed_amount) as total_transaction_value
  from savings_savingsaccount
  group by owner_id
),
-- step 3: joining the owners and transaction summary cte together to create this new cte

clv as (
  select 
    o.id as customer_id,
    o.name,
    o.account_tenure_months,
    ts.total_transaction_value,
    round((ts.total_transaction_value / nullif(o.account_tenure_months, 0)) * 12 * 0.001, 2) as estimated_clv
-- the nullif checks the account_tenure_month and if 0, it returns NULL. The estimated_clv is rounded up to 2.decimal Place
  from owners o
  join transaction_summary ts on ts.owner_id = o.id
)

select * 
from clv
order by estimated_clv desc;
