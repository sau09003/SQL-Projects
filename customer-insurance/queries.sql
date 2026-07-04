create database InsuranceDB;
use InsuranceDB;

rename table `wa_fn-usec_-marketing-customer-value-analysis` to `customer_insurance`;

ALTER TABLE customer_insurance
ADD COLUMN Effective_To_Date_New DATE;

UPDATE customer_insurance
SET Effective_To_Date_New = STR_TO_DATE(`Effective To Date`, '%d-%m-%Y');

SELECT `Effective To Date`
FROM customer_insurance
LIMIT 10;

alter table customer_insurance drop column `Effective To Date`;

-- Basic SQL

-- Display all records
select * from customer_insurance;

-- Find the total number of customers.
select count(distinct customer) from customer_insurance;

-- Display all unique states.
select distinct State from customer_insurance;

-- Count the number of customers in each state.
select state , count(distinct customer) as Number_of_Customer from customer_insurance group by State;

-- Find the number of customers by gender.
select Gender , count(distinct customer) as Number_of_Customer from customer_insurance group by Gender;

-- Find the number of customers by education level.
select Education as Education_level, count(distinct customer) as Number_of_Customer from customer_insurance group by Education;

-- Find the average customer lifetime value.
select round(avg(Customer_Lifetime_value),2) as Avg_Customer_LifeTimeValue from customer_insurance;

-- Find the highest and lowest monthly premium.
select max(Monthly_Premium_Auto) as highest_monthly_premium , min(Monthly_Premium_Auto) as lowest_monthly_premium  from customer_insurance;

-- Find the average income of customers.
select round(avg(income),2) as Avg_Income from customer_insurance;

-- Display the top 10 customers with the highest customer lifetime value.
select customer, Customer_Lifetime_value as Top_10_highest_Customer_LifeTimeValue from customer_insurance order by Customer_Lifetime_value desc limit 10;

-- Find the total number of policies sold.
SELECT SUM(number_of_policies) AS total_policies_sold
FROM customer_insurance;

-- Intermediate SQL

-- Find the average monthly premium for each state.
select state, round(avg(Monthly_Premium_Auto),2) as average_monthly_premium from customer_insurance group by State;

-- Find the total claim amount for each state.
select state, round(sum(Total_Claim_Amount),2) as Total_Claim_Amount from customer_insurance group by State;

-- Find the average customer lifetime value by policy type.
select Policy_Type, round(avg(Customer_Lifetime_value),2) as Avg_Customer_LifeTimeValue from customer_insurance group by Policy_Type;

-- Find the average income by employment status.
select employmentstatus, round(avg(income),2) as Avg_income from customer_insurance group by EmploymentStatus;

-- Find the total premium collected by each sales channel.
SELECT Sales_Channel,
       SUM(Total_Claim_Amount) AS Total_Premium
FROM customer_insurance
GROUP BY Sales_Channel;

-- Find the number of customers for each vehicle class.
SELECT
    vehicle_class,
    COUNT(DISTINCT customer) AS num_customers
FROM customer_insurance
GROUP BY vehicle_class;

-- Find the average claim amount by vehicle size.
select Vehicle_Size, round(avg(Total_Claim_Amount),2) as Total_Premium from customer_insurance group by Vehicle_Size;

-- Find the number of customers by marital status and gender.
SELECT
    marital_status,
    gender,
    COUNT(DISTINCT customer) AS number_of_customers
FROM customer_insurance
GROUP BY marital_status, gender;

-- Find the top 5 states with the highest average customer lifetime value.
select State,round(avg(Customer_Lifetime_value),2) as Top_5_highest_Customer_LifeTimeValue from customer_insurance group by State order by Top_5_highest_Customer_LifeTimeValue desc limit 5;

-- Find the policy type with the highest average monthly premium.
select Policy_Type, round(avg(Monthly_Premium_Auto)) as Highest_Avg_MonthPremium from customer_insurance group by Policy_Type order by Highest_Avg_MonthPremium  desc limit 1;

-- Advanced SQL

-- Find customers whose income is greater than the average income.
select customer, income from customer_insurance where income > (select avg(income) from customer_insurance) ;

-- Find customers whose monthly premium is higher than their state's average premium.
WITH state_avg AS (
    SELECT
        state,
        AVG(monthly_premium_auto) AS avg_premium
    FROM customer_insurance
    GROUP BY state
)
SELECT
    c.customer,
    c.state,
    c.monthly_premium_auto
FROM customer_insurance c
JOIN state_avg s
    ON c.state = s.state
WHERE c.monthly_premium_auto > s.avg_premium;

-- Find the second-highest customer lifetime value.
select max(Customer_Lifetime_Value) as second_highest_customer_lifetime_value from customer_insurance where Customer_Lifetime_Value < (select max(Customer_Lifetime_Value) from customer_insurance);
-- or
SELECT DISTINCT customer_lifetime_value
FROM customer_insurance
ORDER BY customer_lifetime_value DESC
LIMIT 1 OFFSET 1;

-- Rank customers by customer lifetime value within each state.
select customer, Customer_Lifetime_Value, State, rank() over(partition by state order by Customer_Lifetime_Value desc) AS state_rank from customer_insurance;
-- or
SELECT
    customer,
    state,
    customer_lifetime_value,
    RANK() OVER (
        PARTITION BY state
        ORDER BY customer_lifetime_value DESC
    ) AS state_rank
FROM customer_insurance;

-- Find the top 3 customers in each state based on customer lifetime value.
SELECT
    customer,
    state,
    customer_lifetime_value,
    state_rank
FROM (
    SELECT
        customer,
        state,
        customer_lifetime_value,
        RANK() OVER (
            PARTITION BY state
            ORDER BY customer_lifetime_value DESC
        ) AS state_rank
    FROM customer_insurance
) t
WHERE state_rank <= 3;

-- Calculate the running total of total claim amounts.
SELECT
    customer,
    state,
    total_claim_amount,
    SUM(total_claim_amount) OVER (
        ORDER BY customer
    ) AS running_total_claim
FROM customer_insurance;

-- Divide customers into four groups (quartiles) based on income.
SELECT
    customer,
    income,
    NTILE(4) OVER (ORDER BY income) AS income_quartile
FROM customer_insurance;
-- or
SELECT
    customer,
    income,
    NTILE(4) OVER (ORDER BY income) AS income_quartile
FROM customer_insurance
ORDER BY income;

-- Find customers who own more policies than the overall average.
SELECT
    customer,
    number_of_policies
FROM customer_insurance
WHERE number_of_policies >
(
    SELECT AVG(number_of_policies)
    FROM customer_insurance
);

-- Calculate each customer's percentage contribution to the total premium collected.
SELECT
    customer,
    monthly_premium_auto,
    ROUND(
        (monthly_premium_auto / SUM(monthly_premium_auto) OVER ()) * 100,
        2
    ) AS premium_contribution_percent
FROM customer_insurance;

-- Find the customer with the highest claim amount in each state.
SELECT
    customer,
    state,
    total_claim_amount
FROM (
    SELECT
        customer,
        state,
        total_claim_amount,
        ROW_NUMBER() OVER (
            PARTITION BY state
            ORDER BY total_claim_amount DESC
        ) AS rn
    FROM customer_insurance
) t
WHERE rn = 1;

-- Business Problems 

-- Which state generates the highest premium revenue?
SELECT
    state,
    SUM(Monthly_Premium_Auto * 12) AS annual_premium_revenue
FROM customer_insurance
GROUP BY state
ORDER BY annual_premium_revenue DESC
LIMIT 1;

-- Which policy type is the most profitable based on customer lifetime value?
SELECT
    Policy_Type,
    SUM(Customer_Lifetime_Value * 12) AS total_clv
FROM customer_insurance
GROUP BY Policy_Type
ORDER BY total_clv DESC
LIMIT 1;

-- Which sales channel brings in the highest premium revenue?
SELECT
    Sales_Channel,
    SUM(Monthly_Premium_Auto * 12) AS annual_premium_revenue
FROM customer_insurance
GROUP BY Sales_Channel
ORDER BY annual_premium_revenue DESC
LIMIT 1;

-- Which vehicle class has the highest average claim amount?
select vehicle_class, round(avg(Total_Claim_Amount),2) as highest_average_claim_amount from customer_insurance group by Vehicle_Class order by highest_average_claim_amount desc limit 1;

-- Which customer segment (based on income) contributes the most premium revenue?
SELECT
    Coverage,
    SUM(Monthly_Premium_Auto * 12) AS premium_revenue
FROM customer_insurance
GROUP BY Coverage
ORDER BY premium_revenue DESC
LIMIT 1;

-- Identify customers who are good candidates for cross-selling (high income, few policies).
SELECT
    Customer,
    Income,
    COUNT(Policy) AS total_policies
FROM customer_insurance
GROUP BY Customer, Income
HAVING Income > (
    SELECT AVG(Income)
    FROM customer_insurance
)
AND COUNT(Policy) = 1;

-- Identify customers who may be at risk of churning based on policy age, claims, and response.
SELECT
    Customer,
    State,
    Policy_Type,
    Months_Since_Last_Claim,
    Number_of_Open_Complaints,
    Number_of_Policies,
    Response
FROM customer_insurance
WHERE
    Number_of_Open_Complaints > 0
    AND Response = 'No'
    AND Months_Since_Last_Claim > 6
    AND Number_of_Policies = 1;

-- Which education level has the highest average customer lifetime value?
select Education, round(avg(Customer_Lifetime_Value),2) as Highest_AvgCus_Life_Value from customer_insurance group by Education order by Highest_AvgCus_Life_Value desc limit 1;

-- Which employment status has the highest average claim amount?
select EmploymentStatus , round(avg(total_claim_amount),2) as highest_average_claim_amount from customer_insurance group by EmploymentStatus order by highest_average_claim_amount desc limit 1;

-- Create a customer profitability report by comparing customer lifetime value with total claim amount and rank customers from most profitable to least profitable.
SELECT
    Customer,
    Customer_Lifetime_Value,
    Total_Claim_Amount,
    
    (Customer_Lifetime_Value - Total_Claim_Amount) AS profitability,

    RANK() OVER (
        ORDER BY (Customer_Lifetime_Value - Total_Claim_Amount) DESC
    ) AS profit_rank

FROM customer_insurance;


-- or 

SELECT *
FROM (
    SELECT
        Customer,
        Customer_Lifetime_Value,
        Total_Claim_Amount,
        (Customer_Lifetime_Value - Total_Claim_Amount) AS profitability,
        RANK() OVER (
            ORDER BY (Customer_Lifetime_Value - Total_Claim_Amount) DESC
        ) AS profit_rank
    FROM customer_insurance
) t
WHERE profit_rank <= 10;
