SELECT * FROM products; 


SELECT p.product,
COUNT(sales) OVER (PARTITION BY p.product)
FROM products AS p
LEFT JOIN orders AS o
ON p.productID = o.productID;


SELECT OrderID,OrderDate,
COUNT(*) OVER() Totalorders,
COUNT(*) OVER(PARTITION BY CustomerID) orderbycustomer
FROM orders;


SELECT *,
COUNT(*) OVER() Totalcustomers,
COUNT(score) OVER() Totalscores
--COUNT(LastName) OVER() Totallastname
FROM customers;


SELECT 
	OrderID,
	COUNT(*) OVER (PARTITION BY orderID) CheckPK
FROM orders;



--SUM()

SELECT 
	orderID,
	orderDate,
	productID,
	sales,
	SUM(SALES) OVER() totalsales,
	SUM(SALES) OVER(PARTITION BY productID) totalsales
FROM ORDERS;

--COMPARISION ANALYSIS

SELECT 
orderID,
productID,
sales,
SUM(sales) OVER() totalsales,
ROUND(CAST (sales AS float) / SUM(sales) OVER()  * 100,2) as percentage
FROM orders
ORDER BY  percentage DESC;


--AVG()

--Find the average sales of each product

SELECT * FROM orders
SELECT * FROM products


SELECT p.*,
o.*
FROM products p
LEFT JOIN orders o 
ON p.productID = o.productID;


SELECT 
	p.product,
	o.orderID,
	o.sales,
	AVG(COALESCE(sales,0)) OVER(PARTITION BY product) Averagesales,
	AVG(COALESCE(sales,0)) OVER() overallAve
FROM products p 
LEFT JOIN orders o 
ON p.productID = o.productID;





-- 1. find average sales of all orders 
--2. FIND all orders higher than average sales 

-- 1. FIND average sales of all orders 

SELECT 
	orderID,
	AVG(sales) OVER () averagesales
FROM orders;

--2.Find all order higher than averagesales


SELECT * FROM (SELECT 
sales,
	orderID,
	AVG(sales) OVER () averagesales
FROM orders ) as sa
WHERE sales > averagesales;



-- MIN () and MAX()

-- FIND THE HIGHEST AND LOWEST sales of all orders 
-- FIND THE HIGHEST AND LOWEST SALES FOR EACH product
-- Additionally provide details such order ID  order date



-- FIND THE HIGHEST AND LOWEST sales of all orders 
SELECT 
orderID,
productID,
OrderDate,
sales,
MAX(sales) OVER() maxsales,
MIN(sales) OVER() minsales,
MAX(sales) OVER(PARTITION BY productID) maxproductsales,
MIN(sales) OVER(PARTITION BY productID) minproductsales,
sales - MIN(sales) OVER() devation 
FROM orders ;


--SHOW THE EMPLOYEES WHO HAVE THE HIGHEST SALARIES 
SELECT * FROM (
	SELECT 
	*,
	MAX(SALARY) OVER() HIGHESTSALARY
	FROM employees ) AS t
WHERE salary = HIGHESTSALARY;



--RUNNING AND ROLLING TOTAL 

--RUNNING TOTAL 


--MOVING AVERAGE

SELECT 
	OrderID,
	productID,
	orderDate,
	sales
	--AVG(sales) OVER (PARTITION BY month) AS movingaverage
FROM orders;


SELECT 
	OrderID,
	productID,
	orderDate,
	sales,
	AVG(sales) OVER (PARTITION BY productID) AS movingaverage,
	AVG(sales) OVER (PARTITION BY productID ORDER BY orderDate) AS movingaverage
FROM orders;
	


-- Calcuate the moving average of sales for each product over time, including only the next door 


SELECT 
	OrderID,
	productID,
	orderDate,
	sales,
	AVG(sales) OVER (PARTITION BY productID) AS movingaverage,
	AVG(sales) OVER (PARTITION BY productID ORDER BY orderDate) AS movingaverage,
	AVG(sales) OVER (PARTITION BY productID ORDER BY orderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) AS rollingaverage
FROM orders;



