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



-- RANK(), DENSE_RANK(), ROW_NUMBER(), NTILE().

USE LEARN;
--ROW_NUMBER()

SELECT 
	orderID,
	productID,
	sales,
	ROW_NUMBER() OVER(ORDER BY SALES DESC) salesrow,
	RANK()		 OVER(ORDER BY sales DESC) salesrank,
	DENSE_RANK() OVER(ORDER BY sales DESC) saledense
FROM orders;

USE learn;
--TOP N analysis 

SELECT * FROM (
SELECT 
	productID,
	sales,
	Row_number() OVER(PARTITION BY productID ORDER BY sales DESC) maxsales
FROM orders ) as t 
WHERE maxsales = 1;


--BOTTOM N Analysis 

SELECT * FROM (

SELECT 
	productID,
	SUM(sales) Totalsales,
	Row_number() OVER (ORDER BY SUM(sales)) maxsales
FROM orders
GROUP BY productID ) As t 
WHERE maxsales <= 2


-- Generate UNIQUE ID`s 

--Help to assign unique identifier for each row to help paginating 

SELECT 
ROW_NUMBER() OVER (ORDER BY orderID, orderID) UniqueID,
* 
FROM orders ;

--Paginating 

--The Process of breaking down a large data into smaller, more manageble chunks

--IDENTIFY DUPLICATES

--IDENTIFY and Remove duplicates 

SELECT 
ROW_NUMBER() OVER(PARTITION BY ORDERID ORDER BY CREATIONTIME Desc) rn,
*	
FROM orders;


--NTILE()

--Segment all orders into 3 categories : High, Medium and Low sales.

SELECT *,
CASE WHEN Buckets=1 THEN 'High'
	WHEN Buckets=2 THEN 'Meidum'
	WHEN Buckets=3 THEN 'Low'
	END saleseg
	FROM(
SELECT
	orderID,
	sales,
	NTILE(3) OVER(ORDER BY sales DESC) Buckets
FROM orders) t


--Loading the balance in ETL.

-- In order to export the data, divide the orders into groups 

SELECT 
	*,
	NTILE(2) OVER(ORDER BY SALES DESC) Buckets
FROM orders;


--Percentage based Ranking.

--CUME_DIST()

--PERCENT_RANK()

SELECT 
	orderID,
	CUME_DIST() OVER(ORDER BY sales DESC),
	PERCENT_RANK() OVER(ORDER BY sales DESC)
FROM orders;

--LEAD(), LAG(), FIRST_VALUE(), LAST_VALUE()

--LEAD()

USE LEARN;

SELECT 
	orderID,
	productID,
	sales,
	LEAD(sales) OVER ( PARTITION BY ProductID ORDER BY orderDate) as updown,
	LAG(sales) OVER(PARTITION BY ProductID ORDER BY orderDate) as downup,
	ROW_NUMBER() OVER(PARTITION BY productID ORDER BY sales) as rowsnumber
FROM 
	orders;
