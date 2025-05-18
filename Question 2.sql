 -- Step 1: Calculate the Total transactions of all clients on a monthly basis
  with user_monthly_transaction as (
 select 
        sa.owner_id,
        date_format(sa.transaction_date, '%Y-%m') as transaction_month,
        count(*) as monthly_trans_count
    from savings_savingsaccount sa
    group by sa.owner_id, date_format(sa.transaction_date, '%Y-%m')
    ), 		-- this is to get a clear view of all transactions done by clients each month
    
-- Step 2 : Get the average transactions done by all clients
 user_avg_transaction_per_month as (
    select 
        owner_id,
        avg(monthly_trans_count) as avg_transaction_per_month
    from user_monthly_transaction
    group by owner_id
) ,
-- Step 3 : Grouping them into three categories , i.e High, Medium and Low
 user_frequency_category as (
    select 
        owner_id,
        avg_transaction_per_month,
        case 
            when avg_transaction_per_month >= 10 then 'High Frequency'
            when avg_transaction_per_month between 3 and 9 then 'Medium Frequency'
            else 'Low Frequency'
        end as frequency_category
    from user_avg_transaction_per_month
)
-- Step 4 : Selecting the results.
select 
    frequency_category,
    count(owner_id) as customer_count,
    round(avg(avg_transaction_per_month), 1) as avg_transactions_per_month
from user_frequency_category
group by frequency_category
order by customer_count desc;

