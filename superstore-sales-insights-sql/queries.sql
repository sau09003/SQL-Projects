create database superstore_db;

RENAME TABLE `sample - superstore` TO `superstore_sales`;

-- Display all records from the superstore_sales table.
select * from superstore_sales;

-- Show only customer_name, sales, and profit.
select Customer_Name, sales, profit from superstore_sales;

-- Find all orders placed in the West region.
select * from superstore_sales where Region="west";

-- Display products belonging to the Furniture category.
select * from superstore_sales where Category ="Furniture";

-- Find all orders where sales is greater than 1000.
select Order_ID, Customer_Name, Sales from superstore_sales where sales > 1000;

-- Show orders with a discount greater than 20%.
select Order_ID, Product_Name from superstore_sales where Discount > 0.2;

-- List all unique customer segments.
select distinct Segment from superstore_sales;

-- Find the total number of orders.
select count(distinct Order_Id) as Total_Number_OF_Orders from superstore_sales;

-- Find the total number of customers.
select  count(distinct Customer_Name ) as Total_Num_Customer from superstore_sales;

-- Display the top 10 highest sales transactions.
select Order_Id, Customer_Name, Sales from superstore_sales order by sales desc limit 10;

-- Calculate total sales by category.
select round(sum(sales),2) as Total_Sales, Category from superstore_sales group by Category;

-- Calculate total profit by category.
select round(sum(profit),2) as Total_Profit , Category from superstore_sales group by Category;

-- Find the average sales for each sub-category.
select round(avg(sales),2) as Avg_Total_Sales , Sub_Category from superstore_sales group by Sub_Category;

-- Find the top 5 most profitable products.
SELECT Product_Name, SUM(Profit) AS Total_Profit FROM superstore_sales GROUP BY Product_Name ORDER BY Total_Profit DESC LIMIT 5;

-- Find the bottom 5 products by profit.
SELECT Product_Name, SUM(Profit) AS Total_Profit FROM superstore_sales GROUP BY Product_Name ORDER BY Total_Profit asc LIMIT 5;

-- Calculate total sales for each region.
select round(sum(sales),2) as Total_Sales, Region from superstore_sales group by Region;

-- Find the total quantity sold by category.
SELECT Category, SUM(Quantity) AS Total_Quantity FROM superstore_sales GROUP BY Category;

-- Count the number of orders in each ship mode.
select count(distinct product_id) as Count_number_of_orders, Ship_Mode from superstore_sales group by Ship_Mode; 

-- Find the state with the highest total sales.
select round(sum(sales),2) as highest_total_sales, State  from superstore_sales group by state order by highest_total_sales desc limit 1;

-- Find the city with the highest profit.
SELECT City, SUM(Profit) AS Total_Profit FROM superstore_sales GROUP BY City ORDER BY Total_Profit DESC LIMIT 1;

-- Show all orders where profit is negative.
select Order_ID, Product_Name from superstore_sales where Profit < 0.0;

-- Find products that were sold more than 100 times in total.
SELECT
    Product_ID,
    Product_Name,
    SUM(Quantity) AS total_quantity
FROM superstore_sales
GROUP BY Product_ID, Product_Name
HAVING total_quantity > 100;

-- Calculate average discount by region.
select round(avg(discount),2) as Avg_Discount, region from superstore_sales group by Region;

-- Find the customer who placed the most orders.
select customer_name, count(distinct Order_ID) as Order_Qua from superstore_sales group by Customer_name order by Order_Qua desc limit 1;

-- Find the customer with the highest total sales.
select customer_name,round( sum(sales),2) as Highest_Total_Sale from superstore_sales group by Customer_Name order by Highest_Total_Sale desc limit 5;

-- 26.	Find all orders placed in 2016.
select * from superstore_sales where year(Order_Date)='2016'; 

-- 27.	Find total sales for each year.
SELECT YEAR(Order_Date) AS Year,
       ROUND(SUM(Sales), 2) AS Total_Sales
FROM superstore_sales
GROUP BY YEAR(Order_Date)
ORDER BY YEAR(Order_Date);

-- 28.	Find total sales for each month.
SELECT month(Order_Date) AS month,
       ROUND(SUM(Sales), 2) AS Total_Sales
FROM superstore_sales
GROUP BY month(Order_Date)
ORDER BY month(Order_Date);

-- 29.	Which month had the highest sales?
SELECT MONTH(Order_Date) AS Month,
       ROUND(SUM(Sales), 2) AS Total_Sales
FROM superstore_sales
GROUP BY MONTH(Order_Date)
ORDER BY Total_Sales DESC
LIMIT 1;

-- 30.	Count the number of orders placed each year.
SELECT YEAR(Order_Date) AS Year,
       count(distinct Order_ID) AS Total_Order_placed
FROM superstore_sales
GROUP BY YEAR(Order_Date)
ORDER BY YEAR(Order_Date);

-- 31.	Find all orders placed in November.
select * from superstore_sales where month(order_date)=11;

-- 32.	Find the average shipping time (ship_date - order_date) in days.
select avg(datediff(ship_date,order_date)) as shipping_days from superstore_sales;

SELECT ROUND(AVG(DATEDIFF(Ship_Date, Order_Date)), 2) AS Avg_Shipping_Days
FROM superstore_sales;

-- 33.	Find orders that took more than 5 days to ship.
SELECT Order_ID,
       Customer_Name,
       Order_Date,
       Ship_Date,
       DATEDIFF(Ship_Date, Order_Date) AS Shipping_Days
FROM superstore_sales
WHERE DATEDIFF(Ship_Date, Order_Date) > 5;

-- 34.	Find the first and last order dates in the dataset.
SELECT MIN(Order_Date) AS First_Order_Date,
       MAX(Order_Date) AS Last_Order_Date
FROM superstore_sales;

-- 35.	Find total profit for each quarter.
SELECT QUARTER(Order_Date) AS Quarter,
       ROUND(SUM(Profit), 2) AS Total_Profit
FROM superstore_sales
GROUP BY QUARTER(Order_Date)
ORDER BY Quarter;

-- 36.	Rank customers by total sales.
SELECT 
    Customer_Name,
    SUM(Sales) AS Total_Sales,
    RANK() OVER (ORDER BY SUM(Sales) DESC) AS Sales_Rank
FROM superstore_sales
GROUP BY Customer_Name;

-- 37.	Rank products by total profit within each category.
SELECT 
    Category,
    Product_Name,
    SUM(Profit) AS Total_Profit,
    DENSE_RANK() OVER (
        PARTITION BY Category 
        ORDER BY SUM(Profit) DESC
    ) AS Profit_Rank
FROM superstore_sales
GROUP BY Category, Product_Name;

-- 38.	Find the top-selling product in every category.
SELECT Category,
       Product_Name,
       Total_Sales
FROM (
    SELECT Category,
           Product_Name,
           SUM(Sales) AS Total_Sales,
           ROW_NUMBER() OVER (
               PARTITION BY Category
               ORDER BY SUM(Sales) DESC
           ) AS rn
    FROM superstore_sales
    GROUP BY Category, Product_Name
) AS ranked_products
WHERE rn = 1;

-- 39.	Find the second highest sales transaction.
SELECT Order_ID,
       Customer_Name,
       Sales
FROM superstore_sales
WHERE Sales = (
    SELECT MAX(Sales)
    FROM superstore_sales
    WHERE Sales < (
        SELECT MAX(Sales)
        FROM superstore_sales
    )
);
-- or 
SELECT Order_ID,
       Customer_Name,
       Sales
FROM (
    SELECT Order_ID,
           Customer_Name,
           Sales,
           DENSE_RANK() OVER (ORDER BY Sales DESC) AS Sales_Rank
    FROM superstore_sales
) AS ranked_sales
WHERE Sales_Rank = 2;

-- 40.	Calculate the running total of sales by order date.
SELECT Order_Date,
       Sales,
       SUM(Sales) OVER (
           ORDER BY Order_Date
       ) AS Running_Total
FROM superstore_sales;

-- 41.	Find each customer's cumulative sales.
SELECT 
    Customer_Name,
    Order_Date,
    Sales,
    SUM(Sales) OVER (
        PARTITION BY Customer_Name
        ORDER BY Order_Date
    ) AS Cumulative_Sales
FROM superstore_sales;

-- 42.	Find customers whose total sales are above the average customer sales.
SELECT Customer_Name,
       SUM(Sales) AS Total_Sales
FROM superstore_sales
GROUP BY Customer_Name
HAVING SUM(Sales) > (
    SELECT AVG(Customer_Total)
    FROM (
        SELECT SUM(Sales) AS Customer_Total
        FROM superstore_sales
        GROUP BY Customer_Name
    ) AS Customer_Avg_Table
);

-- 43.	Calculate each region's percentage contribution to total sales.
SELECT 
    Region,
    ROUND(SUM(Sales), 2) AS Region_Sales,
    ROUND(
        (SUM(Sales) * 100.0) / (SELECT SUM(Sales) FROM superstore_sales),
        2
    ) AS Sales_Percentage
FROM superstore_sales
GROUP BY Region;

-- 44.	Find the top 3 products in each category using DENSE_RANK().
SELECT 
    Category,
    Product_Name,
    Total_Sales
FROM (
    SELECT 
        Category,
        Product_Name,
        SUM(Sales) AS Total_Sales,
        DENSE_RANK() OVER (
            PARTITION BY Category 
            ORDER BY SUM(Sales) DESC
        ) AS rnk
    FROM superstore_sales
    GROUP BY Category, Product_Name
) ranked_products
WHERE rnk <= 3;

-- 45.	Find the most profitable product in every state.
SELECT 
    State,
    Product_Name,
    Total_Profit
FROM (
    SELECT 
        State,
        Product_Name,
        SUM(Profit) AS Total_Profit,
        DENSE_RANK() OVER (
            PARTITION BY State
            ORDER BY SUM(Profit) DESC
        ) AS rnk
    FROM superstore_sales
    GROUP BY State, Product_Name
) ranked_products
WHERE rnk = 1;

-- 46.	Find customers who purchased from more than one category.
SELECT 
    Customer_Name
FROM superstore_sales
GROUP BY Customer_Name
HAVING COUNT(DISTINCT Category) > 1;

-- 47.	Find products that never generated a profit (total profit ≤ 0).
SELECT 
    Product_Name,
    SUM(Profit) AS Total_Profit
FROM superstore_sales
GROUP BY Product_Name
HAVING SUM(Profit) <= 0;

-- 48.	Calculate month-over-month sales growth.
SELECT 
    Year,
    Month,
    Monthly_Sales,
    ROUND(
        (Monthly_Sales - LAG(Monthly_Sales) OVER (ORDER BY Year, Month)) * 100.0
        / LAG(Monthly_Sales) OVER (ORDER BY Year, Month),
        2
    ) AS MoM_Growth_Percentage
FROM (
    SELECT 
        YEAR(Order_Date) AS Year,
        MONTH(Order_Date) AS Month,
        SUM(Sales) AS Monthly_Sales
    FROM superstore_sales
    GROUP BY YEAR(Order_Date), MONTH(Order_Date)
) t;

-- 49.	Find the highest sales order in each state.
SELECT 
    State,
    Order_ID,
    Customer_Name,
    Sales
FROM (
    SELECT 
        State,
        Order_ID,
        Customer_Name,
        Sales,
        ROW_NUMBER() OVER (
            PARTITION BY State 
            ORDER BY Sales DESC
        ) AS rn
    FROM superstore_sales
) t
WHERE rn = 1;

-- 50.	Create a sales report showing Year, Category, Total Sales, Total Profit, Average Discount.

SELECT 
    YEAR(Order_Date) AS Year,
    Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(AVG(Discount), 2) AS Avg_Discount
FROM superstore_sales
GROUP BY 
    YEAR(Order_Date),
    Category
ORDER BY 
    Year,
    Category;