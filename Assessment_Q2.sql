-- I go with using CTE for this question

WITH customer_monthly_tx AS (
    SELECT 
        owner_id,
        DATE_FORMAT(transaction_date, '%Y-%m') AS ym, -- select the year and month for our counting
        COUNT(*) AS monthly_tx
    FROM savings_savingsaccount
    GROUP BY owner_id, ym
),

avg_monthly_tx_per_customer AS (
    SELECT 
        owner_id,
        AVG(monthly_tx) AS avg_tx_per_month
    FROM customer_monthly_tx
    GROUP BY owner_id
),

categorized_customers AS (
    SELECT 
        owner_id,
        CASE 
            WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
            WHEN avg_tx_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_tx_per_month
    FROM avg_monthly_tx_per_customer
)

SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_tx_per_month), 1) AS avg_transactions_per_month
FROM categorized_customers
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
