--1) Show me the total revenue per customer, sorted highest to lowest

SELECT c.customer_name,
		SUM(p.price*o.quantity) AS Total_Revenue
FROM orders AS o 
INNER JOIN customers as c 
ON o.customer_id = c.customer_id 
INNER JOIN products AS p 
ON o.product_id = p.product_id 
GROUP BY c.customer_name
ORDER BY Total_revenue DESC;


--2) Show only customers who spent more than ₹20,000 in total

SELECT c.customer_name,
		SUM(p.price*o.quantity) AS Total_Revenue
FROM orders AS o 
INNER JOIN customers as c 
ON o.customer_id = c.customer_id 
INNER JOIN products AS p 
ON o.product_id = p.product_id 
GROUP BY c.customer_name
HAVING SUM(p.price*o.quantity) > 20000
ORDER BY Total_revenue DESC;


--3) Show each customer's name, the products they ordered, and the total amount spent per product (price × quantity). Sort by total amount descending.

SELECT c.customer_name,
		p.product_name,
		SUM(p.price*o.quantity) AS total_amount
FROM orders AS o
INNER JOIN customers AS c
ON o.customer_id = c.customer_id
INNER JOIN products AS p 
ON o.product_id = p.product_id
GROUP BY c.customer_name,
			p.product_name
ORDER BY total_amount DESC;


--4) Show only Electronics orders. Display customer name, product name, price, and order date.

SELECT c.customer_name,
		p.product_name,
		p.price,
		o.order_date
FROM orders AS o
INNER JOIN customers AS c
ON o.customer_id =  c.customer_id 
INNER JOIN products AS p 
ON o.product_id = p.product_id 
WHERE p.category = 'Electronics';

--5:Find customers who ordered more than 1 quantity in a single order. Show customer name, product name, and quantity.

SELECT c.customer_name,
	   p.product_name,
	   o.quantity
FROM orders AS o 
INNER JOIN customers AS c
ON o.customer_id = c.customer_id 
INNER JOIN products AS p 
ON o.product_id = p.product_id
WHERE o.quantity > 1;


--6) Show the most expensive product each customer has ever ordered. Display customer name and product name.
SELECT c.customer_name,
	   p.product_name,
	   MAX(p.price) AS expensive_product
FROM orders AS o 
INNER JOIN customers AS c
ON o.customer_id = c.customer_id 
INNER JOIN products AS p 
ON o.product_id = p.product_id 
GROUP BY c.customer_name,
		 p.product_name
ORDER BY expensive_product DESC

--6) Count how many orders each product has received. Show product name and order count, sorted by most ordered.

SELECT p.product_name,
	   COUNT(order_id) AS order_count
FROM orders AS o
INNER JOIN products AS p 
ON o.product_id = p.product_id 
GROUP BY p.product_name
ORDER BY order_count DESC





