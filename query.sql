select * from orders_data ;
select * from payments;
select * from order_items;
select * from reviews;
select * from product;
select * from seller;
select* from customers;
SELECT name
FROM sqlite_master
WHERE type = 'table';

select count(*) from orders_data;
select count(*) from customers;
select count(*) from order_items;
select count(*) from payments;
select count(*) from reviews;
select count(*) from product;
select count(*) from seller;
PRAGMA table_info(customers);

PRAGMA table_info(orders_data);
PRAGMA table_info(order_items);
PRAGMA table_info(product);
PRAGMA table_info(reviews);
PRAGMA table_info(seller);



SELECT COUNT(*) AS total_orders
FROM orders_data;

 

SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM customers;



SELECT COUNT(DISTINCT seller_id) AS total_sellers
FROM seller;



SELECT COUNT(DISTINCT product_id) AS total_products
FROM product;


SELECT ROUND(SUM(price), 2) AS total_revenue
FROM order_items;

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders_data
GROUP BY order_status
ORDER BY total_orders DESC;

SELECT
    customer_state,
    COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;




SELECT
    customer_city,
    COUNT(*) AS total_customers
FROM customers
GROUP BY customer_city
ORDER BY total_customers DESC
LIMIT 10;
SELECT
    customer_unique_id,
    COUNT(DISTINCT customer_id) AS total_orders
FROM customers
GROUP BY customer_unique_id
HAVING COUNT(DISTINCT customer_id) > 1
ORDER BY total_orders DESC;




SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT
        customer_unique_id
    FROM customers
    GROUP BY customer_unique_id
    HAVING COUNT(DISTINCT customer_id) > 1);

SELECT
    c.customer_state,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM customers c

JOIN orders_data o
    ON c.customer_id = o.customer_id

JOIN order_items oi
    ON o.order_id = oi.order_id

GROUP BY c.customer_state
ORDER BY total_revenue DESC;

SELECT
    payment_type,
    COUNT(*) AS total_payments
FROM payments
GROUP BY payment_type
ORDER BY total_payments DESC;




SELECT
    payment_type,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;




SELECT
    payment_type,
    ROUND(AVG(payment_value), 2) AS average_payment
FROM payments
GROUP BY payment_type
ORDER BY average_payment DESC;
sELECT
    review_score,
    COUNT(*) AS total_reviews
FROM reviews
GROUP BY review_score
ORDER BY review_score;




SELECT
    ROUND(AVG(review_score), 2) AS average_review_score
FROM reviews;

SELECT
    review_score,
    COUNT(*) AS total_reviews
FROM reviews
GROUP BY review_score
ORDER BY review_score;




SELECT
    ROUND(AVG(review_score), 2) AS average_review_score
FROM reviews;


 

SELECT
    o.order_status,
    ROUND(AVG(r.review_score), 2) AS average_review_score
FROM orders_data o
JOIN reviews r
 ON o.order_id = r.order_id

GROUP BY o.order_status
ORDER BY average_review_score DESC;

SELECT
strftime('%Y-%m', o.order_purchase_timestamp) AS month,
ROUND(SUM(oi.price), 2) AS monthly_revenue
FROM orders_data o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;

SELECT
seller_id,
ROUND(SUM(price), 2) AS total_revenue,
 RANK() OVER (
        ORDER BY SUM(price) DESC)
     AS seller_rank

FROM order_items

GROUP BY seller_id

ORDER BY seller_rank;

select round(sum(oi.price)/count(distinct o.order_id),2
)as average_order_value
from orders_data o
join order_items oi
on o.order_id=oi.order_id;

-- Revenue by Product Category

SELECT COALESCE(
        t.product_category_name_english,
        p.product_category_name)
     AS category,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
JOIN product p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation t
    ON p.product_category_name = t.product_category_name
GROUP BY category
ORDER BY total_revenue DESC;

-- Delivery Performance

SELECT
CASE
    WHEN order_delivered_customer_date<= order_estimated_delivery_date
            THEN 'On Time'
            ELSE 'Late'
    END AS delivery_status,

    COUNT(*) AS total_orders

FROM orders_data
WHERE order_delivered_customer_date != 'unknown'
GROUP BY delivery_status;

-- Monthly Revenue Growth

WITH monthly_revenue AS (
SELECT
    strftime('%Y-%m', o.order_purchase_timestamp) AS month,

    SUM(oi.price) AS revenue

FROM orders_data o

JOIN order_items oi
     ON o.order_id = oi.order_id

GROUP BY month),

revenue_with_previous AS (

SELECT
    month,
     revenue,

    LAG(revenue) OVER (
      ORDER BY month
    ) AS previous_month_revenue
FROM monthly_revenue
)

SELECT
    month,
ROUND(revenue, 2) AS revenue,

ROUND(previous_month_revenue, 2)
    AS previous_month_revenue,

ROUND(
    (revenue - previous_month_revenue)
    * 100.0 / previous_month_revenue,
        2
 ) AS growth_percentage
FROM revenue_with_previous
ORDER BY month;