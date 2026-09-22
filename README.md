# Brazilian E-Commerce SQL Analysis

## Project Overview

This project analyzes Brazilian e-commerce data using SQL to generate business insights related to orders, customers, products, payments, revenue, and sales performance.

The project focuses on practical SQL analysis using multiple related tables and business-oriented questions.

## Tools Used

- SQL
- SQLite
- VS Code
- Git
- GitHub
- Power BI

## SQL Concepts Used

- SELECT
- WHERE
- DISTINCT
- GROUP BY
- HAVING
- ORDER BY
- LIMIT
- Aggregate Functions
- CASE WHEN
- NULL Handling
- COALESCE
- INNER JOIN
- LEFT JOIN
- Subqueries
- CTEs
- Window Functions
- ROW_NUMBER
- RANK
- DENSE_RANK
- LAG
- LEAD
- COUNT(DISTINCT)
- Revenue Analysis
- Average Order Value
- Month-over-Month Growth

## Analysis Performed

- Total orders
- Average Order Value
- Revenue analysis
- Customer analysis
- Product performance
- Payment type distribution
- Category performance
- Top customers
- Sales ranking
- Monthly revenue
- Month-over-month revenue growth
- Previous month revenue comparison

## Example: Average Order Value

```sql
SELECT
    ROUND(
        SUM(oi.price) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders_data o
JOIN order_items oi
    ON o.order_id = oi.order_id;