USE practice;


--Show customers who purchased products from at least 3 different categories.

SELECT 
	c.customer_id,
	COUNT(DISTINCT p.category) count_of_category
	--o.order_id,
	--p.product_id,
	--p.category
FROM ecom_customers c 
JOIN ecom_orders o 
ON c.customer_id = o.customer_id
JOIN ecom_order_items ot 
ON o.order_id = ot.order_id 
JOIN ecom_products p 
ON ot.product_id = p.product_id
GROUP BY c.customer_id 
HAVING COUNT(DISTINCT p.category) >= 3
ORDER BY count_of_category DESC;

--Show customers who bought BOTH:

SELECT 
	c.customer_id 
FROM ecom_customers c 
JOIN ecom_orders o 
ON c.customer_id = o.customer_id
JOIN ecom_order_items ot 
ON o.order_id = ot.order_id 
JOIN ecom_products p 
ON ot.product_id = p.product_id
WHERE p.category='Electronics'AND p.category='Clothing';

--Show products that have never been ordered.

SELECT 
	p.product_id 
FROM ecom_products p 
LEFT JOIN ecom_order_items ot 
ON p.product_id = ot.product_id 
WHERE ot.order_id IS NULL;

--Show orders containing more than 5 distinct products.

SELECT 
	ot.order_id,
	COUNT(DISTINCT p.product_id) count_products
FROM ecom_order_items ot
JOIN ecom_products p 
ON ot.product_id = p.product_id 
GROUP BY ot.order_id 
HAVING COUNT(DISTINCT p.product_id) > 5;


--Show customers whose total spending is greater than the average spending of all customers.

--1. average spending of all customers

--2.Show customers whose total spending is greater

SELECT 
	c.customer_id
FROM ecom_customers c
JOIN ecom_orders o
ON c.customer_id=o.customer_id
WHERE o.total_amount >(
SELECT 
	AVG(total_amount) average_spending
FROM ecom_orders)




