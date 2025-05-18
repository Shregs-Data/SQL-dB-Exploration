-- step 1: Select all inactivity for savings and investment separately

with inactivity as (
select  -- savings inactivity
    sa.savings_id as plan_id,
    sa.owner_id,
 -- (Type) is assumed that all transactions here are savings as 'is_regular_savings' does not exist in savings_savingsaccount  
  'Savings' as type,
	sa.transaction_date as last_transaction_date,
    datediff(CURDATE(), sa.transaction_date) as inactivity_days 
from savings_savingsaccount sa

inner join (
 -- This inner join - subquery is needed so as not to have duplicates in the owner_id column as one owner can have multiple savings
    SELECT 
        owner_id,
        MAX(transaction_date) as last_transaction_date
    FROM savings_savingsaccount
    GROUP BY owner_id
) latest ON sa.owner_id = latest.owner_id -- joining the innerjoins to the main query
        and sa.transaction_date = latest.last_transaction_date 

union
-- the Next query for the investment inactivity
select 
    pp.id as plan_id,
    pp.owner_id,
   case -- to check for investment and savings as 'is_a_fund' & 'is_regular_savings' exists
            when pp.is_a_fund = 1 then 'Investment'
            when pp.is_regular_savings = 1 then 'Savings'
            else 'Unknown'
        end as type,
	pp.created_on as last_transaction_date,
    datediff(curdate(), pp.created_on) as inactivity_days -- difference between latest date and current date
from plans_plan pp
inner join (
-- to select only the latest transaction 
    select owner_id,
        max(created_on) as last_transaction_date
    FROM plans_plan
    GROUP BY owner_id ) as latest on pp.owner_id = latest.owner_id 
        and pp.created_on = latest.last_transaction_date 
)
-- finan query to select all the tables
select *
from inactivity
where inactivity_days > 365 and (type like '%savings%' or type like '%investment%')
