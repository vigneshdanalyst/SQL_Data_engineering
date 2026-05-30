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


USE practice;
-- Pro domination of joins with group by and having and Aggregations 

SELECT 
	c.customer_id,
	COUNT(o.order_id) as total_orders
FROM ecom_customers c 
JOIN ecom_orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING COUNT(o.order_id) > 3;

--2.

	SELECT 
		c.customer_id,
		SUM(o.total_amount) total_spending
	FROM ecom_customers c
	JOIN ecom_orders o 
	ON c.customer_id = o.customer_id
	GROUP BY c.customer_id 
	HAVING SUM(o.total_amount) > 10000;

--3
SELECT 
	p.category, 
	SUM(ot.quantity) total_products_sold
FROM ecom_products p
JOIN ecom_order_items ot 
ON p.product_id = ot.product_id 
GROUP BY p.category
ORDER BY total_products_sold DESC;

--4
SELECT 
	o.order_id,
	COUNT(DISTINCT ot.product_id) distinct_product_count
FROM ecom_customers c
JOIN ecom_orders o  
ON c.customer_id = o.customer_id 
JOIN ecom_order_items ot 
ON o.order_id = ot.order_id 
JOIN ecom_products p
ON ot.product_id = p.product_id 
GROUP BY o.order_id
HAVING COUNT(DISTINCT ot.product_id) >= 2;

--5 

SELECT 
	c.customer_id,
	COUNT(DISTINCT p.category) distinct_categories_bought
FROM ecom_customers c 
JOIN ecom_orders o 
ON c.customer_id = o.customer_id
JOIN ecom_order_items ot
ON o.order_id = ot.order_id
JOIN ecom_products p 
ON ot.product_id = p.product_id
GROUP BY c.customer_id
HAVING COUNT(DISTINCT p.category) >= 3;

--6

SELECT 
	p.product_name,
	SUM(ot.quantity) as total_quantity_sold 
FROM ecom_customers c
JOIN ecom_orders o 
ON c.customer_id = o.customer_id
JOIN ecom_order_items ot 
ON o.order_id = ot.order_id
JOIN ecom_products p 
ON ot.product_id = p.product_id
GROUP BY p.product_name
HAVING SUM(ot.quantity) > 20 ;

--7
SELECT TOP 5
	c.customer_id,
	SUM(ot.quantity) total_quantity_purchased
FROM ecom_customers c
JOIN ecom_orders o 
ON c.customer_id=o.customer_id
JOIN ecom_order_items ot 
ON o.order_id = ot.order_id
GROUP BY c.customer_id
ORDER BY total_quantity_purchased DESC;


--8 
SELECT 
	p.category,
	AVG(ot.unit_price) as average_product_price
FROM ecom_products p 
JOIN ecom_order_items ot 
ON p.product_id = ot.product_id 
GROUP BY p.category 
HAVING AVG(ot.unit_price) > 5000;

--9

SELECT 
	c.customer_id,
	COUNT(DISTINCT ot.product_id) total_distinct_products
FROM ecom_customers c 
JOIN ecom_orders o 
ON c.customer_id = o.customer_id
JOIN ecom_order_items ot 
ON o.order_id=ot.order_id 
GROUP BY c.customer_id
HAVING COUNT(DISTINCT ot.product_id) > 5;

--10

SELECT 
	o.order_id,
	SUM(ot.quantity * ot.unit_price) total_order_value 
FROM ecom_orders o 
JOIN ecom_order_items ot 
ON o.order_id = ot.order_id 
GROUP BY o.order_id
HAVING SUM(ot.quantity * ot.unit_price) > 15000;

--11

SELECT 
	c.customer_id,
	SUM(o.total_amount) total_spending,
	AVG(o.total_amount) average_spending
FROM ecom_customers c
JOIN ecom_orders o 
ON c.customer_id = o.customer_id 
GROUP BY c.customer_id
HAVING SUM(o.total_amount) > AVG(o.total_amount);

--12 

SELECT 
	p.category,
	SUM(ot.quantity*ot.unit_price) as total_revenue,
	AVG(ot.quantity*ot.unit_price) as average_revenue
FROM ecom_products p 
JOIN ecom_order_items ot 
ON p.product_id = ot.product_id 
GROUP BY p.category 
HAVING SUM(ot.quantity*ot.unit_price) > AVG(ot.quantity*ot.unit_price);


--13 

SELECT 
	c.customer_id 
FROM ecom_customers c
JOIN ecom_orders o 
ON c.customer_id = o.customer_id
JOIN ecom_order_items ot 
ON o.order_id = ot.order_id
JOIN ecom_products p 
ON ot.product_id = p.product_id
GROUP BY c.customer_id
HAVING COUNT(p.category='Electronics') > 0
AND COUNT(p.category='Clothing') > 0;

--14 

SELECT 
	p.product_id,
	COUNT(DISTINCT c.city) as city_count
FROM ecom_customers c
JOIN ecom_orders o 
ON c.customer_id = o.customer_id
JOIN ecom_order_items ot 
ON o.order_id = ot.order_id
JOIN ecom_products p 
ON ot.product_id = p.product_id
GROUP BY p.product_id
HAVING COUNT(DISTINCT c.city) >= 3;

--15

SELECT TOP 1
	p.category,
	COUNT(p.category) total_number_purchased
FROM ecom_products p 
JOIN ecom_order_items ot
ON p.product_id = ot.product_id
GROUP by p.category 
ORDER BY total_number_purchased DESC;






