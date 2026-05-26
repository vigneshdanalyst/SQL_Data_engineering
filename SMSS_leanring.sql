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
	LEAD(sales) OVER ( PARTITION BY ProductID ORDER BY SALES) as updown,
	LAG(sales) OVER(PARTITION BY ProductID ORDER BY SALES ) as downup,
	ROW_NUMBER() OVER(PARTITION BY productID ORDER BY sales) as rowsnumber,
	FIRST_VALUE(sales) OVER(PARTITION BY productID ORDER BY sales) as firstvalue,
	LAST_VALUE(SALES) OVER(ORDER BY sales) AS lastvalue
FROM 
	orders;


-- Month-Over-Month Analysis

--Analyze the MoM perfomance by finding the percentage change in sales between the current and previous Month.

--Time series Analysis 
	-- Year over year analysis 
	--Month over month analysis 

SELECT *,CurrentMonthsales-Previousmonthsales as salesperformace,
ROUND(CAST((CurrentMonthsales-Previousmonthsales) AS float)/Previousmonthsales*100,1) AS MoM_percentage

FROM (

SELECT 
	MONTH(orderdate) OrderMonth,
	SUM(sales) CurrentMonthsales,
	LAG(SUM(sales)) OVER(ORDER BY MONTH(orderdate)) Previousmonthsales
FROM orders
GROUP BY MONTH(orderdate)) t 


--Customer Retention Analysis 

-- Analyze customer Loyalty by Ranking customers Based on the average number of days between orders 

SELECT 
	CustomerID,
	AVG( daysuntilnext) Avgdays,
	RANK() OVER (ORDER BY COALESCE(AVG( daysuntilnext),0000)) RankAvg
FROM
(
SELECT
	orderID,
	CustomerID,
	OrderDate Currentorder,
	LEAD(orderdate) OVER(partition BY CustomerID ORDER BY orderDate) as nextorder,
	DATEDIFF(Day,OrderDate,LEAD(orderdate) OVER(partition BY CustomerID ORDER BY orderDate)) daysuntilnext
FROM orders) t 
GROUP BY customerID



--First_Value()

--Access a value from the first row within a window 

SELECT 
	orderID,
	productID,
	sales,
	FIRST_VALUE(sales) OVER (PARTITION BY productID ORDER BY sales) Lowestsales,
	LAST_VALUE(sales) OVER (PARTITION BY productID ORDER BY sales ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) Highestsales
FROM orders;


--Subquery 

--Types of subquery 

--Dependancy 
/* 1. Non correaleated subquery
2.Correleated subquery */

/* Result type
1. Sclaer 
2. Table 
3. Row 

*/

--1. Find the products that have a price higher than the avaerage price of all products 


SELECT * 
FROM (
SELECT 
	productID,
	price,
	AVG(price) OVER() Avgprice 
FROM products) as T
WHERE price > Avgprice;

--Rabk customers based on their total amount of sales 

--i) find the total of sales for each customer 

SELECT 
	*,
	RANK() OVER(ORDER BY totalsales DESC) customerrank
FROM (
SELECT 
	CUSTOMERID,
	SUM(sales) totalsales
FROM orders
GROUP BY customerID) as T


--Subquery in SELECT clause 

--Must be scaler query 

--Show the productID, Productname, prices and the total number of orders 

SELECT 
	productID,
	product,
	price,
	(SELECT COUNT(*) FROM orders) Totalorders
FROM products;


--Join Clause Subquery 

--  Subquery in Join clauses 

--Show all customers details and find the total order of each customer 


--show all customer details 

SELECT c.* ,
o.Totalorders
FROM customers c 
LEFT JOIN (
SELECT 
	customerID,
	COUNT(*) Totalorders
FROM orders
GROUP BY customerID) o
ON c.customerID = o.CustomerID

-- Find the products that have a price higher than the average price of all products 


SELECT * FROM products 
WHERE price > (SELECT AVG(price) as average_price
FROM products)

--Show the details of orders made by customers in germany 

SELECT 
	* 
FROM orders
WHERE customerID IN (SELECT customerID FROM customers WHERE country = 'Germany');

--Show the details of orders made by customers not in germany 
SELECT 
	* 
FROM orders
WHERE customerID NOT IN (SELECT customerID FROM customers WHERE country = 'Germany')


-- Any operators 

--Find female employee whose salaries are greater than the salaries of any male employees 


SELECT 
	employeeID,
	firstname,
	gender,
	salary
FROM employees
WHERE gender ='F'
AND salary > ANY 

(SELECT 
	salary
FROM employees
WHERE gender ='M')


--ALL Opertors 

SELECT 
	employeeID,
	firstname,
	gender,
	salary
FROM employees
WHERE gender ='F'
AND salary > ALL

(SELECT 
	salary
FROM employees
WHERE gender ='M')




--CTE (Common Table expression ) 

--Standalone CTE 
--Define and used indepentantly runs without realying on other CTE and query 

USE learn;


WITH totalsales AS (
  SELECT 
    CustomerID,
    SUM(sales) AS Totalsales
  FROM orders
  GROUP BY CustomerID
)
--Step the last order date for each customer 
,Last_orderdate AS 
(
	SELECT
		customerID,
		MAX(orderdate) Last_order
	FROM orders 
	GROUP BY customerID
	)
	--Rank the customer based on total sales per customer 
	,Customer_rank AS 
	(
	SELECT 
		customerID,
		totalsales,
		RANK() OVER(ORDER BY totalsales DESC) cutomerrank
	FROM totalsales
	)
	--Segmenting the customer based on their total sales 
	,customer_segmentation AS (
	SELECT 
		customerID,
		CASE WHEN totalsales> 100 THEN 'High'
		WHEN totalsales> 80 THEN 'Medium'
		ELSE 'Low'
	END customersegment
	FROM totalsales )



SELECT 
	c.customerID,
	c.firstname,
	c.lastname,
	cts.totalsales,
	lt.last_order,
	cr.cutomerrank,
	cs.customersegment
FROM customers c 
LEFT JOIN totalsales cts
ON cts.customerID=c.customerID
LEFT JOIN last_orderdate lt
ON lt.customerid = c.customerid 
LEFT JOIN Customer_rank cr
ON cr.customerID = c.customerID
LEFT JOIN customer_segmentation cs
ON cs.CustomerID=c.CustomerID
ORDER BY cts.totalsales DESC;


-- Generate sequence of numbers from 1 to 20 


WITH series AS (
--Anchor query 
SELECT 1 AS mynumber 
UNION ALL 
--Recusrive query 
SELECT 
mynumber+1
FROM series
WHERE mynumber < 10
)

SELECT * FROM series
OPTION (MAXRECURSION 10)








	


