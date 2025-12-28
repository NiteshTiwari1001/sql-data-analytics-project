/*
=============================================================
Create Database and Schemas (MySQL Version)
=============================================================
WARNING:
    This script will DROP the database if it exists.
    All data will be permanently deleted.
*/
USE mysql;

SHOW VARIABLES LIKE 'secure_file_priv';

-- Drop and recreate database
DROP DATABASE IF EXISTS DataWarehouseAnalytics;

CREATE DATABASE DataWarehouseAnalytics;
USE DataWarehouseAnalytics;

-- Create schema (MySQL supports schemas same as database namespaces)
CREATE SCHEMA IF NOT EXISTS gold;

-- =========================
-- Create Tables
-- =========================

DROP TABLE IF EXISTS gold.dim_customers;

CREATE TABLE gold.dim_customers (
   quantity customer_key INT,
    customer_id INT,
    customer_number VARCHAR(50),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    country VARCHAR(50),
    marital_status VARCHAR(50),
    gender VARCHAR(50),
    birthdate DATE,
    create_date DATE
);

DROP TABLE IF EXISTS gold.dim_products;

CREATE TABLE gold.dim_products (
    product_key INT,
    product_id INT,
    product_number VARCHAR(50),
    product_name VARCHAR(50),
    category_id VARCHAR(50),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    maintenance VARCHAR(50),
    cost INT,
    product_line VARCHAR(50),
    start_date DATE
);

DROP TABLE IF EXISTS gold.fact_sales;

CREATE TABLE gold.fact_sales (
    order_number VARCHAR(50),
    product_key INT,
    customer_key INT,
    order_date DATE,
    shipping_date DATE,
    due_date DATE,
    sales_amount INT,
    quantity TINYINT,
    price INT
);

-- =========================
-- Load Data from CSV Files
-- =========================

TRUNCATE TABLE gold.dim_customers;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sql-data-analytics-project/datasets/csv-files/gold.dim_customers.csv'
INTO TABLE gold.dim_customers
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(
  customer_key,
  customer_id,
  customer_number,
  first_name,
  last_name,
  country,
  marital_status,
  gender,
  @birthdate,
  @create_date
)
SET
  birthdate   = NULLIF(@birthdate, ''),
  create_date = NULLIF(@create_date, '');

TRUNCATE TABLE gold.dim_products;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sql-data-analytics-project/datasets/csv-files/gold.dim_products.csv'
INTO TABLE gold.dim_products
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(
 product_key,
 product_id,
 product_number,
 product_name,
 category_id,
 category,
 subcategory,
 maintenance,
 cost,
 product_line,
 @start_date
)
SET start_date = NULLIF(@start_date, '');

TRUNCATE TABLE gold.fact_sales;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sql-data-analytics-project/datasets/csv-files/gold.fact_sales.csv'
INTO TABLE gold.fact_sales
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(
 order_number,
 product_key,
 customer_key,
 @order_date,
 @shipping_date,
 @due_date,
 sales_amount,
 quantity,
 price
)
SET
 order_date    = NULLIF(@order_date, ''),
 shipping_date = NULLIF(@shipping_date, ''),
 due_date      = NULLIF(@due_date, '');
