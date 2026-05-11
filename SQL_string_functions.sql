--CONCAT

-- combaine multiple rows into one column

SELECT 
		customer_name,
		city,
		CONCAT(customer_name,' ',city) AS name_country
FROM customers;

--UPPER and LOWER

-- Change into uppercase and lower cases

SELECT 
	UPPER(customer_name),
	LOWER(customer_name),
	TRIM (customer_name),
	LENGTH(customer_name)
FROM customers;

-- TRIM 

--REMOVE THE leading and trailing space 

-- REPLACE 

--Replace the specific charatcer 
SELECT
	CUSTOMER_NAME,
	REPLACE(CUSTOMER_NAME, ' ', '')
FROM
	CUSTOMERS;


--Left and Right function 

SELECT customer_name,
       LEFT(customer_name, 2) AS first_char,
       RIGHT(customer_name, 2) AS last_char,
       CONCAT(LEFT(customer_name, 2), RIGHT(customer_name, 2)) AS email
FROM customers;


--Substring 

--Extract the part of the string 

SELECT customer_name,
		SUBSTRING(customer_name,2,LENGTH(customer_name)) 
FROM customers;


