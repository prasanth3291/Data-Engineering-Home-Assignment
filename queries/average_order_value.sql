SELECT 
    month, 
    AVG(total_sales_amount) AS avg_order_value
FROM 
    transformed_sales_data
WHERE 
    year = 2023
GROUP BY 
    month
ORDER BY 
    month