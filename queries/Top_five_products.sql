SELECT
product_id,
SUM(total_sales_amount) AS total_sales
FROM
transformed_sales_data
WHERE
year = 2023
GROUP BY
product_id
ORDER BY
total_sales DESC
LIMIT 5