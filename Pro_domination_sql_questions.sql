
-- Most Valuable Customer

SELECT TOP 20
	c.customer_id,
	COUNT(o.order_id) total_orders,
	SUM(ot.quantity*ot.unit_price) total_spending
FROM ecom_customers c
JOIN ecom_orders o
ON c.customer_id = o.customer_id
JOIN ecom_order_items ot
ON o.order_id = ot.order_id
GROUP BY c.customer_id
ORDER BY total_spending DESC;

--Which cities generate the most revenue?

SELECT 
	city,
	COUNT(customer_id) total_customers,
	SUM(total_amount) total_revenue
FROM ecom_orders
GROUP BY city
ORDER BY total_revenue;


--Which product categories are making money but not selling many units?

SELECT 
	p.category,
	SUM(o.total_amount) as total_revenue,
	SUM(ot.quantity) as total_quantity_sold
FROM ecom_products p 
JOIN ecom_order_items ot
ON p.product_id=ot.product_id
JOIN ecom_orders o 
ON ot.order_id = o.order_id
GROUP BY p.category
ORDER BY total_quantity_sold;


--Which customers haven't ordered in the last 90 days?

SELECT 
	customer_id
FROM ecom_orders
WHERE order_date >= DATEADD(DAY,-90,GETDATE());
	
	

--Who are our repeat customers?

SELECT 
	customer_id,
	COUNT(order_id) as total_orders 
FROM ecom_orders o 
GROUP BY customer_id 
HAVING COUNT(order_id) > 5;

--Which products are sitting in inventory but nobody buys?

SELECT
	p.product_id
FROM ecom_products p 
LEFT JOIN ecom_order_items ot 
ON p.product_id = ot.product_id 
WHERE ot.order_id IS NULL;

--Customers who buy from multiple categories.

SELECT 
	o.customer_id,
	COUNT(p.category) as count_of_categories
FROM ecom_orders o 
JOIN ecom_order_items ot 
ON o.order_id = ot.order_id 
JOIN ecom_products p 
ON ot.product_id = p.product_id
GROUP BY o.customer_id
HAVING COUNT(p.category) > 2;



--Customers whose spending is above average customer spending.
USE practice;
--finding customers 
SELECT 
	o.customer_id,
SUM(o.total_amount) AS total_spending
FROM ecom_orders o
GROUP BY o.customer_id
HAVING SUM(o.total_amount) >= AVG(o.total_amount)
ORDER BY total_spending DESC;







	
	