create database coffee_db;

SELECT * FROM coffee_db.sales;

SELECT * FROM coffee_db.customers;

SELECT * FROM coffee_db.products;

SELECT * FROM coffee_db.city;

-- 1. Total Sales
SELECT 
    SUM(total) AS Revenue
FROM
    sales;

-- 2. Total Customers
SELECT 
    COUNT(*) AS Total_Customer
FROM
    customers;

-- 3.Total Products
SELECT 
    COUNT(*) AS Total_Products
FROM
    products;

-- 4. Average Rating
SELECT 
    ROUND(AVG(rating), 2) AS Avg_Rating
FROM
    sales;

-- 5. Number of Cities
SELECT 
    COUNT(*) AS Num_OF_City
FROM
    city;

-- 6. Most Expensive Coffee

SELECT 
    *
FROM
    products
ORDER BY price DESC
LIMIT 1;

-- 7. Cheapest Coffee
SELECT 
    *
FROM
    products
ORDER BY price ASC
LIMIT 1;

-- 8. Highest Sale
SELECT 
    *
FROM
    sales
ORDER BY total DESC
LIMIT 1;
SELECT 
    MAX(total)
FROM
    sales;

-- 9. Lowest Sale
SELECT 
    MIN(total)
FROM
    sales;

-- 10. Total Orders
SELECT 
    COUNT(*)
FROM
    sales;

-- 11. Revenue by Product
SELECT 
    products.product_name,
    SUM(sales.total * products.price) AS Revenue
FROM
    sales
        JOIN
    products ON products.product_id = sales.product_id
GROUP BY product_name
ORDER BY Revenue DESC;

-- 12. Orders by Product
SELECT 
    p.product_name, COUNT(*) orders
FROM
    products p
        JOIN
    sales s ON p.product_id = s.product_id
GROUP BY p.product_name
ORDER BY orders DESC;

-- 13. Average Rating by Product

SELECT 
    p.product_name, ROUND(AVG(s.rating), 2) AS Average_Rating
FROM
    products p
        JOIN
    sales s ON p.product_id = s.product_id
GROUP BY p.product_name
ORDER BY Average_Rating DESC;

-- 14. Revenue by City
SELECT 
    c.city_name, SUM(s.total) Revenue
FROM
    sales s
        JOIN
    customers cu ON s.customer_id = cu.customer_id
        JOIN
    city c ON cu.city_id = c.city_id
GROUP BY c.city_name
ORDER BY Revenue DESC;

-- 15. Customers in Each City

SELECT 
    city_name, COUNT(*) AS Num_OF_Customer
FROM
    customers
        JOIN
    city ON city.city_id = customers.city_id
GROUP BY city_name;

-- 16. Average Purchase per Customer

SELECT 
    customer_id, ROUND(AVG(total), 2) Avg_Purchase
FROM
    sales
GROUP BY customer_id;

-- 17. Monthly Revenue
SELECT 
    MONTH(sale_date) Month, SUM(total) Revenue
FROM
    sales
GROUP BY MONTH(sale_date)
ORDER BY Revenue DESC;

-- 18. Sales Count per Month
SELECT 
    MONTH(sale_date), COUNT(*)
FROM
    sales
GROUP BY MONTH(sale_date);

-- 19. Top 5 Customers
SELECT 
    customer_id, SUM(total) Spending
FROM
    sales
GROUP BY customer_id
ORDER BY Spending DESC
LIMIT 5;

-- 20. Revenue vs Estimated Rent
SELECT 
    c.city_name, SUM(s.total) AS Revenue, c.estimated_rent
FROM
    sales s
        JOIN
    customers cu ON s.customer_id = cu.customer_id
        JOIN
    city c ON cu.city_id = c.city_id
GROUP BY c.city_name , c.estimated_rent;

-- 21. Top Product in Every City
WITH ProductSales AS
(
SELECT
c.city_name,
p.product_name,
SUM(s.total) Revenue,
RANK() OVER(PARTITION BY c.city_name
ORDER BY SUM(s.total) DESC) rk
FROM sales s
JOIN customers cu
ON s.customer_id=cu.customer_id
JOIN city c
ON cu.city_id=c.city_id
JOIN products p
ON s.product_id=p.product_id
GROUP BY
c.city_name,
p.product_name
)
SELECT *
FROM ProductSales
WHERE rk=1;

-- 22. Top Customer in Each City
WITH CustomerSales AS
(
SELECT
c.city_name,
cu.customer_name,
SUM(s.total) Revenue,
RANK() OVER(PARTITION BY c.city_name
ORDER BY SUM(s.total) DESC) rk
FROM sales s
JOIN customers cu
ON s.customer_id=cu.customer_id
JOIN city c
ON cu.city_id=c.city_id
GROUP BY
c.city_name,
cu.customer_name
)
SELECT *
FROM CustomerSales
WHERE rk=1;

-- 23. Running Revenue
SELECT
sale_date,
SUM(total)
OVER(ORDER BY sale_date)
Running_Revenue
FROM sales;

-- 24. Revenue Share of Products
SELECT
p.product_name,
SUM(s.total) Revenue,
ROUND(
100*SUM(s.total)/
SUM(SUM(s.total)) OVER(),2
) Revenue_Percentage
FROM sales s
JOIN products p
ON s.product_id=p.product_id
GROUP BY p.product_name;


-- 25. Customers Who Bought Multiple Products

SELECT 
    customer_id, COUNT(DISTINCT product_id) Products
FROM
    sales
GROUP BY customer_id
HAVING COUNT(DISTINCT product_id) > 1;

-- 26. Highest Rated Product

SELECT 
    p.product_name, AVG(s.rating) Rating
FROM
    sales s
        JOIN
    products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY Rating DESC
LIMIT 1;

-- 27. Average Revenue per City
SELECT 
    c.city_name, ROUND(AVG(s.total), 2) Avg_Revenue
FROM
    sales s
        JOIN
    customers cu ON s.customer_id = cu.customer_id
        JOIN
    city c ON cu.city_id = c.city_id
GROUP BY c.city_name;

-- 28. Customer Lifetime Value
SELECT 
    cu.customer_name, SUM(s.total) Lifetime_Value
FROM
    sales s
        JOIN
    customers cu ON s.customer_id = cu.customer_id
GROUP BY cu.customer_name
ORDER BY Lifetime_Value DESC;

-- 29. Price vs Sales
SELECT 
    p.product_name, p.price, SUM(s.total) Revenue
FROM
    sales s
        JOIN
    products p ON s.product_id = p.product_id
GROUP BY p.product_name , p.price;

-- 30. Create a Sales Summary View
CREATE VIEW Sales_Summary AS
    SELECT 
        s.sale_id,
        s.sale_date,
        cu.customer_name,
        c.city_name,
        p.product_name,
        p.price,
        s.total,
        s.rating
    FROM
        sales s
            JOIN
        customers cu ON s.customer_id = cu.customer_id
            JOIN
        city c ON cu.city_id = c.city_id
            JOIN
        products p ON s.product_id = p.product_id;

SELECT 
    *
FROM
    Sales_Summary;






