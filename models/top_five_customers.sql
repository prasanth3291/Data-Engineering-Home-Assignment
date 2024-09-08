SELECT 
    c.name AS customer_name, 
    SUM(t.total_sales_amount) AS total_sales
FROM 
    transformed_sales_data t
LEFT JOIN 
    raw_customers_data c
ON 
    t.customer_id = c.id
WHERE 
    t.year = 2023
GROUP BY 
    c.name
ORDER BY 
    total_sales DESC
LIMIT 5
