# Data Engineering Home Assignment

This document outlines the key steps and decisions made during the completion of the data engineering home assignment.

---

## 1. Environment Setup

### 1.1 Snowflake Account Creation
- A free Snowflake account was created for the 30-day trial period.
- The necessary compute and storage resources were set up.

### 1.2 Database Setup
- Created a new database named `home_assignment` to store all relevant tables for the assignment.
- Set the role as **sysadmin** to manage permissions effectively.
  - Granted read and write permissions to the database to ensure smooth access for operations.

### 1.3 Warehouse Setup
- Set up a warehouse named `compute_wh` in Snowflake.
  - This warehouse will be used to perform queries and transformations efficiently.

---

## 2. dbt Setup

### 2.1 Python Setup
- **Python Installation Check**: Since Python was already installed on my system, I confirmed its presence by running:
    ```bash
    python --version
    ```
- If Python was not installed, I would have downloaded and installed it from the official [Python website](https://www.python.org/downloads/).

### 2.2 Installing dbt for Snowflake
- Installed dbt with the Snowflake adapter using the command:
    ```bash
    pip install dbt-snowflake
    ```
- Verified that the installation was successful by checking the dbt version:
    ```bash
    dbt --version
    ```

### 2.3 Creating the `.dbt` Folder
- Navigated to the system user folder and searched for the `.dbt` folder. Since it did not exist, I created it manually to store dbt configuration files.

### 2.4 Setting Up `profiles.yml`
- Inside the `.dbt` folder, I created a `profiles.yml` file and configured it for Snowflake as follows:
    ```yaml
    dbt_banxware_assignment:
      outputs:
        dev:
          account: <your_snowflake_account_details>
          database: home_assignment
          password: <your_password>
          host: <your host name>
          port: 443
          role: sysadmin
          schema: public
          threads: 4
          type: snowflake
          user: <your username>
          warehouse: COMPUTE_WH
      target: dev
    ```

### 2.5 Setting Up `dbt_project.yml`
- I created the `dbt_project.yml` file in the root directory of the dbt project and added the following configuration:
    ```yaml
    name: 'dbt_banxware_assignment'
    profile: 'dbt_banxware_assignment'
    ```
- To verify that I had successfully established a connection to the Snowflake cluster, I ran the following command from the root of the `dbt_banxware_assignment` folder:
    ```bash
    dbt debug
    ```

- This confirmed that the connection to Snowflake was successful and that dbt was able to communicate with the cluster.


---

## 3. CSV Files Ingestion

### 3.1 Setting Up the Seed Folder
- A **seed folder** was created inside the dbt project directory to store the provided CSV files (`customers.csv` and `sales.csv`).
  
### 3.2 Copying CSV Files
- The following files were copied to the `seed/` folder:
  - `customers.csv`
  - `sales.csv`

### 3.3 Ingesting CSV Files as Tables
- The `dbt seed` command was used to load these CSV files into Snowflake as tables:
    ```cmd
    dbt seed
    ```
  - The `sales.csv` file was ingested as the `raw_sales_data` table.
  - The `customers.csv` file was ingested as the `raw_customer_data` table.

---
## 4. Renaming the Seeded Tables

### 4.1 Default Table Names
- After running the `dbt seed` command, the following tables were created in Snowflake:
  - `sales` (from `sales.csv`)
  - `customers` (from `customers.csv`)

### 4.2 Renaming Tables Using SnowSQL
- To rename the tables to follow the required `raw_` naming convention, I used **SnowSQL**.
  - **Note**: SnowSQL is a command-line tool provided by Snowflake. It needs to be downloaded from [here](https://docs.snowflake.com/en/user-guide/snowsql-install-config) if not already installed.
- Once SnowSQL was downloaded and installed, I logged in using the following command:
    ```bash
    snowsql -a <account_name> -u <username>
    ```
- After logging in, I ran the following SQL commands to rename the tables:
    ```sql
    ALTER TABLE public.sales RENAME TO public.raw_sales_data;
    ALTER TABLE public.customers RENAME TO public.raw_customer_data;
    ```
  - These commands successfully renamed the tables as:
    - `raw_sales_data` (from `sales`)
    - `raw_customer_data` (from `customers`)

### 4.3 Alternative Method
- Alternatively, the same `ALTER TABLE` commands can be run in the **Snowflake UI Worksheet** to rename the tables.

## 5. Creating a View in Snowflake

### 5.1 Objective
- A view was created to transform the data in the `raw_sales_data` table by extracting `year`, `month`, and `day` from the `order_date`, and calculating the total sales amount using the formula:
  - `total_sales_amount = quantity * price`

### 5.2 SQL for Creating the View
- The SQL below was used to create the view:

    ```sql
    WITH base AS (
        SELECT
            sales.order_id,
            customers.id AS customer_id,       
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
        LEFT JOIN raw_customer_data AS customers
            ON sales.customer_id = customers.id  
    )

    SELECT * 
    FROM base;
    ```
### 5.3 Queries for Analysis

#### 5.3.1 Top 5 Products by Total Sales in 2023

- This query retrieves the top 5 products by total sales amount in the year 2023.

    ```sql
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
    LIMIT 5;
    ```

#### 5.3.2 Top 5 Customers by Total Sales in 2023

- This query identifies the top 5 customers by total sales amount in 2023.

    ```sql
    SELECT
        customer_id,
        SUM(total_sales_amount) AS total_sales
    FROM
        transformed_sales_data
    WHERE
        year = 2023
    GROUP BY
        customer_id
    ORDER BY
        total_sales DESC
    LIMIT 5;
    ```

#### 5.3.3 Average Order Value by Month in 2023

- This query calculates the average order value for each month in 2023.

    ```sql
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
        month;
    ```

#### 5.3.4 Customer with the Highest Order Volume in October 2023

- This query retrieves the customer with the highest order volume for October 2023.

    ```sql
    SELECT
        customer_id,
        COUNT(order_id) AS order_volume
    FROM
        transformed_sales_data
    WHERE
        year = 2023
        AND month = 10
    GROUP BY
        customer_id
    ORDER BY
        order_volume DESC
    LIMIT 1;
    ```

---



