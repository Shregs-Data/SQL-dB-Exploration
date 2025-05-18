-- step 1: aggregate savings by user
with savings_agg as (
    select 
        owner_id, 
        count(id) as savings_count,
        sum(confirmed_amount) as total_savings
    from savings_savingsaccount
    group by owner_id
),

-- step 2: aggregate investments by user
investments_agg as (
    select 
        owner_id, 
        count(id) as investment_count,
        sum(amount) as total_investments
    from plans_plan
    group by owner_id
)

-- step 3: join with user table
select  
    uc.id as owner_id,  
    concat(uc.first_name, ' ', uc.last_name) as name,  
    coalesce(sa.savings_count, 0) as savings_count,
    coalesce(ia.investment_count, 0) as investment_count,
    coalesce(sa.total_savings, 0) + coalesce(ia.total_investments, 0) as total_deposits
from users_customuser uc
left join savings_agg sa on sa.owner_id = uc.id
left join investments_agg ia on ia.owner_id = uc.id
where coalesce(sa.savings_count, 0) > 0 or coalesce(ia.investment_count, 0) > 0 -- filters out the 0 from the query
and coalesce(sa.total_savings, 0) + coalesce(ia.total_investments, 0) > 0
order by total_deposits desc;


