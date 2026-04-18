-- Explore all objects in the Database
SELECT * FROM INFORMATION_SCHEMA.TABLES

-- Explore all objects in the Database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'

USE datawarehouseanalytics

-- Explore all countries our customers come from
SELECT DISTINCT country FROM gold.dim_customers

-- Explore all major cagetories
SELECT DISTINCT category, subcategory, product_name FROM gold.dim_products
ORDER BY 1, 2, 3

-- Find the date of the first order and last order
-- How many years of sales available
SELECT MIN(order_date) AS first_order_date,
MAX(order_date) AS last_order_date,
DATEDIFF(month, MIN(order_date),MAX(order_date)) AS order_range_months
FROM gold.fact_sales

-- Find the youngest and the oldest customer
SELECT
MIN(birthdate) AS oldest_birthdate,
DATEDIFF( year, MIN(birthdate), GETDATE()) AS oldest_age,
MAX(birthdate) AS youngest_birthdate,
DATEDIFF( year, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers

-- Find the Total sales
SELECT SUM(sales_amount) AS Total_sales FROM gold.fact_sales
-- Find how many items were sold
SELECT SUM(quantity) AS Total_items FROM gold.fact_sales
--Find the average selling price
SELECT AVG(price) AS avg_sales_amount FROM gold.fact_sales
--Find the total number of orders
SELECT COUNT(DISTINCT order_number) AS Total_orders FROM gold.fact_sales
--Find the total number of Products
SELECT COUNT(DISTINCT product_name) AS total_products FROM gold.dim_products
--Find the total number of customers
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.dim_customers
--Find the total number of customers that have placed orders
SELECT COUNT(DISTINCT customer_key) AS total_products FROM gold.fact_sales

-- Report for the key metrics
SELECT 'Total sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity',SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average price',AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Orders',COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Products',COUNT(product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Nr. Customers',COUNT(customer_key) FROM gold.dim_customers

-- Find total customers by countries
SELECT
country,
COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC

--Find total customers by gender
SELECT
gender,
COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC

--Find total products by category
SELECT
category,
COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC

--What are the average costs by category
SELECT
category,
AVG(cost) AS avg_costs
FROM gold.dim_products
GROUP BY category
ORDER BY avg_costs DESC

--What is the total revenue generated for each category
SELECT p.category,
SUM(f.sales_amount) as total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY total_revenue DESC

--What is the total revenue generated for each customer
SELECT c.customer_key,
c.first_name,
c.last_name,
SUM(f.sales_amount) as total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY c.customer_key,
c.first_name,
c.last_name
ORDER BY total_revenue DESC

-- What is the distribution of sold items accross countries?

SELECT c.country,
SUM(f.quantity) AS total_sold_items
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC

--Which 5 products generate the highest revenue?
SELECT TOP 5 p.product_name,
SUM(f.sales_amount) as total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC

--What are the 5 worst performing products in terms of sales?
SELECT TOP 5 p.product_name,
SUM(f.sales_amount) as total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue

--FInd the TOP 10 customers who have generated the highest revenue
SELECT TOP 10 c.customer_key,
c.first_name,
c.last_name,
SUM(f.sales_amount) as total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY c.customer_key,
c.first_name,
c.last_name
ORDER BY total_revenue DESC

--The 3 customers with the fewest orders placed
SELECT TOP 3 c.customer_key,
c.first_name,
c.last_name,
COUNT(DISTINCT order_number) as total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY c.customer_key,
c.first_name,
c.last_name
ORDER BY total_orders ASC