WITH base AS (
    SELECT
        sales.order_id,
        customers.id AS customer_id,        -- Use the correct 'ID' from raw_customer_data
        sales.order_date,
        sales.product_id,
        sales.product_name,
        EXTRACT(YEAR FROM TO_DATE(sales.order_date, 'MM/DD/YYYY')) AS year,  -- Convert order_date to DATE
        EXTRACT(MONTH FROM TO_DATE(sales.order_date, 'MM/DD/YYYY')) AS month,  -- Convert order_date to DATE
        EXTRACT(DAY FROM TO_DATE(sales.order_date, 'MM/DD/YYYY')) AS day,     -- Convert order_date to DATE
        sales.quantity,
        sales.price,
        sales.quantity * sales.price AS total_sales_amount,  -- Calculate total sales amount,
        sales.order_status
    FROM raw_sales_data AS sales
    -- Join with raw_customer_data to get the PK for customer_id
    LEFT JOIN raw_customers_data AS customers
        ON sales.customer_id = customers.id  -- Corrected to use 'ID' from raw_customer_data
)

SELECT * 
FROM base
