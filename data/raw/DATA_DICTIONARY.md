# E-commerce dataset

Tables: customers, products, orders, order_items.

Relationships:
- customers.customer_id -> orders.customer_id
- orders.order_id -> order_items.order_id
- products.product_id -> order_items.product_id
