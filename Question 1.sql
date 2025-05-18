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
order by total_deposits desc;

-- NOTE: Some clients have an investment with recorded count with 0 deposits
-- E.x : owner_id: 00372ecec6e449c595fb44b7a5f2c9c0
