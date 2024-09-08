# Data Engineering Home Assignment

## Overview
This project demonstrates the ingestion, transformation, and analysis of sales and customer data using Snowflake and dbt. The dataset includes sales data and customer information, and we perform operations such as creating views and running queries for analysis.

## Prerequisites

Before running this project, ensure you have the following:

- **Snowflake account** (free 30-day trial can be used)
- **dbt** (Data Build Tool) installed with the Snowflake adapter
- **Python** installed on your machine

## Setup Instructions

### 1. Clone the Repository
Clone the repository to your local machine:

```bash
git clone https://github.com/prasanth3291/Data-Engineering-Home-Assignment.git

```
### 2. Set Up Snowflake
- Create a Snowflake account (if you don't have one already).
- Create a new database named `home_assignment` in Snowflake.
- Set up a warehouse named `compute_wh`.
- Assign the `sysadmin` role and grant necessary read and write permissions to the database.

## 3. Install dbt

Ensure dbt is installed on your machine. If it’s not already installed, you can install dbt with the Snowflake adapter using the following command:

```bash
pip install dbt-snowflake
```
## 4. Configure dbt

### 4.1 Set Up `profiles.yml`

Create a `profiles.yml` file in the `~/.dbt/` directory and configure it for Snowflake:

```yaml
dbt_banxware_assignment:
  outputs:
    dev:
      type: snowflake
      account: <your_snowflake_account_details>
      user: <your_username>
      password: <your_password>
      role: sysadmin
      warehouse: compute_wh
      database: home_assignment
      schema: public
      threads: 4
      port: 443
  target: dev
```
## 4.2 Set Up `dbt_project.yml`

In the root directory of your dbt project, create or edit the `dbt_project.yml` file with the following minimal configuration:

```yaml
name: 'dbt_banxware_assignment'
profile: 'dbt_banxware_assignment'
```
## 4.3. Verify the dbt Connection

After setting up your `profiles.yml` and `dbt_project.yml` files, use the `dbt debug` command to check if dbt can successfully connect to your Snowflake account.

### Run the Following Command:

```bash
dbt debug
```
## 5. Seeding Data in dbt

Seeding allows you to load CSV files into your data warehouse using dbt. You can use seeds to create tables from static CSV data.

### 5.1 Place CSV Files in the `seeds` Directory

1. Create a `seeds` directory inside your dbt project folder (if it doesn’t already exist).
2. Place your CSV files (e.g., `customers.csv`, `sales.csv`) inside the `seeds` directory.


### 5.2 Run the `dbt seed` Command

Once your CSV files are placed in the `seeds` directory, run the following command to load the CSV files into Snowflake:

```bash
dbt seed

```
### Run the Models
Use the following command to run the models, which will create views and apply transformations on the data:

```bash
dbt run
```
## 7. Run the Queries

After successfully running your dbt models and seeding the data, you can execute the SQL queries located in the `queries/` folder. You can run these queries in the Snowflake worksheet or your preferred SQL editor. 

7.1. Use the `dbt run-operation` command to execute each query file.

### Example Command to Run a Query:

```bash
dbt run-operation <operation_name>
```
## 8. Debugging

If you encounter issues connecting to Snowflake or running dbt models, you can debug your configuration by running the following command:

```bash
dbt debug
```
#### Author
Prasanth Kizhakkedath


