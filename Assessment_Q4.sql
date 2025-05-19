SELECT 
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    
    -- Calculate tenure in months between signup date and today
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
    COUNT(s.id) AS total_transactions,
    
    -- Estimated CLV using the formula provided
    ROUND(
        (
            COUNT(s.id) / 
            GREATEST(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 1) -- Avoid division by zero
        ) * 12 * 
        (0.001 * AVG(s.confirmed_amount / 100.0)), 2
    ) AS estimated_clv

FROM users_customuser u
LEFT JOIN savings_savingsaccount s 
    ON u.id = s.owner_id

GROUP BY u.id, u.name, u.date_joined
ORDER BY estimated_clv DESC;
