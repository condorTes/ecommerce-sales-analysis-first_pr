
-- ============================================================
-- E-COMMERCE SALES ANALYSIS
-- ============================================================
-- Database: ecommerce_analysis
-- Main rule:
-- Revenue is calculated only for Completed orders.
-- Transaction price from order_items is used for revenue.
-- ============================================================


-- ============================================================
-- 0. DATABASE AND TABLES
-- ============================================================

CREATE DATABASE ecommerce_analysis;

USE ecommerce_analysis;


-- ----------------------------
-- Customers
-- ----------------------------

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    city VARCHAR(100),
    segment VARCHAR(50),
    signup_date DATE
);


-- ----------------------------
-- Products
-- ----------------------------

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(100),
    unit_price DECIMAL(10, 2)
);


-- ----------------------------
-- Orders
-- ----------------------------

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status VARCHAR(20),
    payment_method VARCHAR(50)
);


-- ----------------------------
-- Order items
-- ----------------------------

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10, 2)
);


-- ============================================================
-- 1. DATA VALIDATION
-- ============================================================

SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM customers

UNION ALL

SELECT 'products', COUNT(*)
FROM products

UNION ALL

SELECT 'orders', COUNT(*)
FROM orders

UNION ALL

SELECT 'order_items', COUNT(*)
FROM order_items;


-- ============================================================
-- 2. REVENUE AND AVERAGE ORDER VALUE
-- ============================================================

-- Total revenue from Completed orders

SELECT
    SUM(order_items.quantity * order_items.unit_price) AS revenue
FROM orders
JOIN order_items
    ON orders.order_id = order_items.order_id
WHERE orders.status = 'Completed';


-- Revenue by order

SELECT
    orders.order_id,
    SUM(unit_price * quantity) AS order_revenue
FROM order_items
JOIN orders
    ON order_items.order_id = orders.order_id
WHERE status = 'Completed'
GROUP BY orders.order_id;


-- Average Order Value

SELECT
    AVG(order_revenue) AS avg_order_value
FROM (
    SELECT
        orders.order_id,
        SUM(unit_price * quantity) AS order_revenue
    FROM order_items
    JOIN orders
        ON order_items.order_id = orders.order_id
    WHERE status = 'Completed'
    GROUP BY orders.order_id
) AS order_revenues;


-- ============================================================
-- 3. DATA QUALITY: MISSING PRICES
-- ============================================================

-- Missing prices in all order items

SELECT
    COUNT(*) AS missing_price_items,
    SUM(quantity) AS missing_price_quantity
FROM order_items
WHERE unit_price IS NULL;


-- Missing prices in Completed orders

SELECT
    COUNT(*) AS missing_price_items,
    SUM(quantity) AS missing_price_quantity
FROM order_items
JOIN orders
    ON orders.order_id = order_items.order_id
WHERE orders.status = 'Completed'
  AND order_items.unit_price IS NULL;


-- Share of Completed order items with missing prices

SELECT
    COUNT(*) AS completed_items,
    SUM(unit_price IS NULL) AS missing_price_items,
    ROUND(
        SUM(unit_price IS NULL) / COUNT(*) * 100,
        2
    ) AS missing_price_pct
FROM order_items
JOIN orders
    ON orders.order_id = order_items.order_id
WHERE orders.status = 'Completed';


-- ============================================================
-- 4. REVENUE BY MONTH
-- ============================================================

SELECT
    YEAR(orders.order_date) AS year,
    MONTH(orders.order_date) AS month,
    SUM(order_items.unit_price * order_items.quantity) AS revenue
FROM orders
JOIN order_items
    ON orders.order_id = order_items.order_id
WHERE orders.status = 'Completed'
GROUP BY
    YEAR(orders.order_date),
    MONTH(orders.order_date)
ORDER BY
    YEAR(orders.order_date),
    MONTH(orders.order_date);


-- ============================================================
-- 5. REVENUE BY CATEGORY
-- ============================================================

SELECT
    category,
    SUM(order_items.unit_price * quantity) AS revenue
FROM products
JOIN order_items
    ON products.product_id = order_items.product_id
JOIN orders
    ON orders.order_id = order_items.order_id
WHERE status = 'Completed'
GROUP BY category
ORDER BY revenue DESC;


-- ============================================================
-- 6. REVENUE BY PRODUCT
-- ============================================================

-- Top 10 products by revenue

SELECT
    products.product_id,
    product_name,
    SUM(quantity * order_items.unit_price) AS product_revenue
FROM products
JOIN order_items
    ON products.product_id = order_items.product_id
JOIN orders
    ON order_items.order_id = orders.order_id
WHERE status = 'Completed'
GROUP BY
    products.product_id,
    product_name
ORDER BY product_revenue DESC
LIMIT 10;


-- ============================================================
-- 7. CUSTOMER ANALYSIS
-- ============================================================

-- Top 10 customers by revenue

SELECT
    customers.customer_id,
    customers.first_name,
    customers.city,
    SUM(quantity * order_items.unit_price) AS customer_revenue
FROM customers
JOIN orders
    ON customers.customer_id = orders.customer_id
JOIN order_items
    ON order_items.order_id = orders.order_id
WHERE status = 'Completed'
GROUP BY
    customers.customer_id,
    customers.first_name,
    customers.city
ORDER BY customer_revenue DESC
LIMIT 10;


-- Orders per customer

SELECT
    customer_id,
    COUNT(*) AS order_count
FROM orders
WHERE status = 'Completed'
GROUP BY customer_id
ORDER BY order_count DESC
LIMIT 10;


-- Number of unique customers with at least one Completed order

SELECT
    COUNT(DISTINCT customer_id) AS unique_completed_customers
FROM orders
WHERE status = 'Completed';


-- Repeat customers

SELECT
    (
        SELECT COUNT(DISTINCT customer_id)
        FROM orders
        WHERE status = 'Completed'
    )
    -
    (
        SELECT COUNT(*)
        FROM (
            SELECT customer_id
            FROM orders
            WHERE status = 'Completed'
            GROUP BY customer_id
            HAVING COUNT(*) = 1
        ) AS one_time_customers
    ) AS repeat_customers;


-- Repeat customer share

SELECT
    ROUND(
        (
            (
                SELECT COUNT(DISTINCT customer_id)
                FROM orders
                WHERE status = 'Completed'
            )
            -
            (
                SELECT COUNT(*)
                FROM (
                    SELECT customer_id
                    FROM orders
                    WHERE status = 'Completed'
                    GROUP BY customer_id
                    HAVING COUNT(*) = 1
                ) AS one_time_customers
            )
        )
        /
        (
            SELECT COUNT(DISTINCT customer_id)
            FROM orders
            WHERE status = 'Completed'
        ) * 100,
        2
    ) AS repeat_customer_pct;


-- Average number of Completed orders per customer

SELECT
    ROUND(
        COUNT(*) / COUNT(DISTINCT customer_id),
        2
    ) AS avg_orders_per_customer
FROM orders
WHERE status = 'Completed';


-- ============================================================
-- 8. REVENUE BY CITY
-- ============================================================

SELECT
    customers.city,
    SUM(quantity * unit_price) AS revenue
FROM customers
JOIN orders
    ON customers.customer_id = orders.customer_id
JOIN order_items
    ON order_items.order_id = orders.order_id
WHERE status = 'Completed'
GROUP BY customers.city
ORDER BY revenue DESC;


-- Revenue and revenue share by city

SELECT
    customers.city,
    SUM(quantity * unit_price) AS revenue,
    SUM(quantity * unit_price) /
    (
        SELECT SUM(quantity * unit_price)
        FROM order_items
        JOIN orders
            ON order_items.order_id = orders.order_id
        WHERE status = 'Completed'
    ) * 100 AS revenue_pct
FROM customers
JOIN orders
    ON customers.customer_id = orders.customer_id
JOIN order_items
    ON order_items.order_id = orders.order_id
WHERE status = 'Completed'
GROUP BY customers.city
ORDER BY revenue DESC;


-- ============================================================
-- 9. CUSTOMER SEGMENTS
-- ============================================================

-- Revenue by segment

SELECT
    segment,
    SUM(quantity * unit_price) AS revenue
FROM customers
JOIN orders
    ON customers.customer_id = orders.customer_id
JOIN order_items
    ON order_items.order_id = orders.order_id
WHERE status = 'Completed'
GROUP BY segment
ORDER BY revenue DESC;


-- Revenue and revenue share by segment

SELECT
    segment,
    SUM(quantity * unit_price) AS revenue,
    SUM(quantity * unit_price) /
    (
        SELECT SUM(quantity * unit_price)
        FROM order_items
        JOIN orders
            ON order_items.order_id = orders.order_id
        WHERE status = 'Completed'
    ) * 100 AS revenue_pct
FROM customers
JOIN orders
    ON customers.customer_id = orders.customer_id
JOIN order_items
    ON order_items.order_id = orders.order_id
WHERE status = 'Completed'
GROUP BY segment
ORDER BY revenue DESC;


-- Completed orders by segment

SELECT
    segment,
    COUNT(*) AS completed_orders
FROM customers
JOIN orders
    ON customers.customer_id = orders.customer_id
WHERE status = 'Completed'
GROUP BY segment
ORDER BY completed_orders DESC;


-- Revenue, orders and AOV by segment

SELECT
    segment,
    SUM(quantity * unit_price) AS revenue,
    COUNT(DISTINCT orders.order_id) AS completed_orders,
    SUM(quantity * unit_price)
        / COUNT(DISTINCT orders.order_id) AS avg_order_value
FROM customers
JOIN orders
    ON customers.customer_id = orders.customer_id
JOIN order_items
    ON order_items.order_id = orders.order_id
WHERE status = 'Completed'
GROUP BY segment
ORDER BY revenue DESC;


-- ============================================================
-- 10. ORDERS WITHOUT ORDER ITEMS
-- ============================================================

-- Completed orders without order items

SELECT
    COUNT(*) AS orders_without_items
FROM orders
LEFT JOIN order_items
    ON orders.order_id = order_items.order_id
WHERE orders.status = 'Completed'
  AND order_items.order_id IS NULL;


-- Completed orders without order items by segment

SELECT
    customers.segment,
    COUNT(*) AS orders_without_items
FROM customers
JOIN orders
    ON customers.customer_id = orders.customer_id
LEFT JOIN order_items
    ON orders.order_id = order_items.order_id
WHERE orders.status = 'Completed'
  AND order_items.order_id IS NULL
GROUP BY customers.segment
ORDER BY orders_without_items DESC;


-- Number of orders that have at least one order item

SELECT
    COUNT(DISTINCT order_id) AS orders_with_items
FROM order_items;


-- ============================================================
-- 11. PAYMENT METHODS
-- ============================================================

-- Completed orders by payment method

SELECT
    payment_method,
    COUNT(*) AS completed_orders
FROM orders
WHERE status = 'Completed'
GROUP BY payment_method
ORDER BY completed_orders DESC;


-- Revenue by payment method

SELECT
    payment_method,
    SUM(quantity * unit_price) AS revenue
FROM orders
JOIN order_items
    ON orders.order_id = order_items.order_id
WHERE status = 'Completed'
GROUP BY payment_method
ORDER BY revenue DESC;


-- Revenue share by payment method

SELECT
    payment_method,
    SUM(quantity * unit_price) AS revenue,
    SUM(quantity * unit_price) /
    (
        SELECT SUM(quantity * unit_price)
        FROM order_items
        JOIN orders
            ON orders.order_id = order_items.order_id
        WHERE status = 'Completed'
    ) * 100 AS revenue_pct
FROM orders
JOIN order_items
    ON orders.order_id = order_items.order_id
WHERE status = 'Completed'
GROUP BY payment_method
ORDER BY revenue DESC;


-- ============================================================
-- 12. ORDER STATUS
-- ============================================================

-- Number of orders by status

SELECT
    status,
    COUNT(*) AS count_orders
FROM orders
GROUP BY status
ORDER BY count_orders DESC;


-- Order share by status

SELECT
    status,
    COUNT(*) AS count_orders,
    COUNT(*) /
    (
        SELECT COUNT(DISTINCT order_id)
        FROM orders
    ) * 100 AS count_orders_pct
FROM orders
GROUP BY status
ORDER BY count_orders DESC;


-- Revenue by order status

SELECT
    status,
    SUM(quantity * unit_price) AS revenue
FROM orders
JOIN order_items
    ON orders.order_id = order_items.order_id
GROUP BY status
ORDER BY revenue DESC;


-- Revenue share by order status

SELECT
    status,
    SUM(quantity * unit_price) AS revenue,
    SUM(quantity * unit_price) /
    (
        SELECT SUM(quantity * unit_price)
        FROM order_items
        JOIN orders
            ON orders.order_id = order_items.order_id
    ) * 100 AS revenue_pct
FROM orders
JOIN order_items
    ON orders.order_id = order_items.order_id
GROUP BY status
ORDER BY revenue DESC;


-- ============================================================
-- 13. MONTH-OVER-MONTH REVENUE CHANGE
-- ============================================================

SELECT
    YEAR(orders.order_date) AS year,
    MONTH(orders.order_date) AS month,

    SUM(order_items.unit_price * order_items.quantity) AS revenue,

    LAG(
        SUM(order_items.unit_price * order_items.quantity)
    ) OVER (
        ORDER BY
            YEAR(orders.order_date),
            MONTH(orders.order_date)
    ) AS prev_revenue,

    SUM(order_items.unit_price * order_items.quantity)
    -
    LAG(
        SUM(order_items.unit_price * order_items.quantity)
    ) OVER (
        ORDER BY
            YEAR(orders.order_date),
            MONTH(orders.order_date)
    ) AS revenue_change,

    (
        SUM(order_items.unit_price * order_items.quantity)
        -
        LAG(
            SUM(order_items.unit_price * order_items.quantity)
        ) OVER (
            ORDER BY
                YEAR(orders.order_date),
                MONTH(orders.order_date)
        )
    )
    /
    LAG(
        SUM(order_items.unit_price * order_items.quantity)
    ) OVER (
        ORDER BY
            YEAR(orders.order_date),
            MONTH(orders.order_date)
    ) * 100 AS revenue_change_pct

FROM orders
JOIN order_items
    ON orders.order_id = order_items.order_id
WHERE orders.status = 'Completed'
GROUP BY
    YEAR(orders.order_date),
    MONTH(orders.order_date)
ORDER BY
    YEAR(orders.order_date),
    MONTH(orders.order_date);


-- ============================================================
-- 14. MONTHLY AVERAGE ORDER VALUE
-- ============================================================

SELECT
    YEAR(orders.order_date) AS year,
    MONTH(orders.order_date) AS month,

    SUM(order_items.unit_price * order_items.quantity) AS revenue,

    COUNT(DISTINCT orders.order_id) AS completed_orders,

    SUM(order_items.unit_price * order_items.quantity)
        / COUNT(DISTINCT orders.order_id) AS avg_order_value

FROM orders
JOIN order_items
    ON orders.order_id = order_items.order_id
WHERE orders.status = 'Completed'
GROUP BY
    YEAR(orders.order_date),
    MONTH(orders.order_date)
ORDER BY
    YEAR(orders.order_date),
    MONTH(orders.order_date);


-- ============================================================
-- 15. TOP-3 PRODUCTS WITHIN EACH CATEGORY
-- ============================================================

WITH product_revenue AS (

    SELECT
        category,
        product_name,
        SUM(
            order_items.unit_price * order_items.quantity
        ) AS revenue

    FROM products
    JOIN order_items
        ON order_items.product_id = products.product_id

    JOIN orders
        ON order_items.order_id = orders.order_id

    WHERE status = 'Completed'

    GROUP BY
        category,
        product_name
),

result AS (

    SELECT
        category,
        product_name,
        revenue,

        RANK() OVER (
            PARTITION BY category
            ORDER BY revenue DESC
        ) AS product_rank

    FROM product_revenue
)

SELECT
    category,
    product_name,
    revenue,
    product_rank
FROM result
WHERE product_rank <= 3;

