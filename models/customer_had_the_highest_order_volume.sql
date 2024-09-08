SELECT 
    c.name AS customer_name, 
    COUNT(t.order_id) AS order_volume
FROM 
    transformed_sales_data t
LEFT JOIN 
    raw_customers_data c
ON 
    t.customer_id = c.id
WHERE 
    t.year = 2023 
    AND t.month = 10  -- October
GROUP BY 
    c.name
ORDER BY 
    order_volume DESC
LIMIT 1
