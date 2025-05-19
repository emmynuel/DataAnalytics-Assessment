-- I prefer using CTE for problems like this

WITH funded_plans AS (
    SELECT 
        p.id AS plan_id,
        p.owner_id,
        p.is_regular_savings,
        p.is_a_fund
    FROM plans_plan p
    JOIN savings_savingsaccount s ON p.id = s.plan_id
    WHERE s.confirmed_amount > 0
),

-- Ingredient: Get users with saving plans
savings_customers AS (
    SELECT owner_id
    FROM funded_plans
    WHERE is_regular_savings = 1
    GROUP BY owner_id
),

-- Ingredient: Get users with Investment plans
investment_customers AS (
    SELECT owner_id
    FROM funded_plans
    WHERE is_a_fund = 1
    GROUP BY owner_id
),

-- Count total saving plans each user has
savings_counts AS (
    SELECT owner_id, COUNT(*) AS savings_count
    FROM funded_plans
    WHERE is_regular_savings = 1
    GROUP BY owner_id
),

-- Count total investment plans each user has
investment_counts AS (
    SELECT owner_id, COUNT(*) AS investment_count
    FROM funded_plans
    WHERE is_a_fund = 1
    GROUP BY owner_id
),

-- Ingredient: Get the total deposits of each user 
total_deposits AS (
    SELECT owner_id, SUM(confirmed_amount)/100 AS total_deposits -- convert to naira from kobo
    FROM savings_savingsaccount
    GROUP BY owner_id
)

-- Cook: Join the tables to finalize the query
SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COALESCE(sc.savings_count, 0) AS savings_count,
    COALESCE(ic.investment_count, 0) AS investment_count,
    ROUND(COALESCE(td.total_deposits, 0), 2) AS total_deposits
FROM users_customuser u
JOIN savings_customers s ON u.id = s.owner_id
JOIN investment_customers i ON u.id = i.owner_id
LEFT JOIN savings_counts sc ON u.id = sc.owner_id
LEFT JOIN investment_counts ic ON u.id = ic.owner_id
LEFT JOIN total_deposits td ON u.id = td.owner_id
ORDER BY total_deposits DESC;
