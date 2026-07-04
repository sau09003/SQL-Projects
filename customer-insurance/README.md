# 📊 Insurance Customer Analytics Project (SQL)

## 📌 Project Overview
This project focuses on analyzing an insurance customer dataset using SQL to generate meaningful business insights. The analysis covers customer behavior, profitability, risk patterns, and revenue contribution across different segments such as state, policy type, coverage, education, and employment status.

The goal is to simulate a real-world insurance analytics case study and demonstrate strong SQL skills for data analysis.

---

## 🗂️ Dataset Information

**Table Name:** `customer_insurance`

### Key Columns:
- Customer, State, Gender, Education, Marital_Status
- Income, EmploymentStatus
- Policy_Type, Policy, Coverage
- Monthly_Premium_Auto
- Total_Claim_Amount
- Customer_Lifetime_Value
- Number_of_Policies
- Months_Since_Last_Claim
- Number_of_Open_Complaints
- Vehicle_Class, Vehicle_Size
- Sales_Channel
- Effective_To_Date_New

---

## 🧹 Data Preparation Steps
- Renamed dataset table to `customer_insurance`
- Converted date column using `STR_TO_DATE`
- Dropped original date column after transformation
- Cleaned and structured dataset for analysis

---

## 📊 Exploratory Data Analysis (EDA)

- Total number of customers
- Customers by state, gender, education
- Average income of customers
- Average customer lifetime value
- Distribution of vehicle classes and policies

---

## 📈 Business Analysis

### 🌍 State & Revenue Insights
- State with highest premium revenue
- Total claim amount by state
- Average monthly premium by state

### 📢 Sales Channel Analysis
- Sales channel generating highest revenue

### 🚗 Vehicle Insights
- Vehicle class with highest claim amount
- Claim patterns by vehicle size

### 📜 Policy Insights
- Most profitable policy type based on CLV
- Total policies sold

---

## 🧠 Advanced SQL Analysis

### 👥 Customer Segmentation
- Income-based segmentation (Low / Middle / High)
- Income quartile analysis using NTILE()

### 💰 Profitability Analysis
- Customer profitability = CLV − Total Claim Amount
- Ranked customers based on profitability
- Identified top high-value customers

### ⚠️ Risk & Churn Analysis
- Identified customers at risk of churn based on:
  - Number of complaints
  - Policy age
  - Response behavior
  - Claim activity

### 🔎 Window Function Analysis
- Ranking customers within states (RANK)
- Running total of claims
- Percentage contribution to total premium

---

## 🎯 Key Business Insights

- Certain states contribute significantly higher premium revenue.
- A small group of customers generates most of the profitability.
- High complaints and low engagement increase churn risk.
- Policy type and vehicle class strongly influence claims.
- High-income customers contribute more to revenue.

---

## 📸 Screenshots Included

The following outputs are included in the `/screenshots` folder:
- Dataset preview
- Revenue analysis (state & sales channel)
- Profitability ranking
- Churn risk analysis
- Advanced SQL window functions
- Key business insights queries

---

## 🛠️ SQL Concepts Used

- SELECT, WHERE, GROUP BY, ORDER BY
- Aggregate Functions (SUM, AVG, COUNT)
- Subqueries
- CTE (WITH clause)
- Window Functions:
  - RANK()
  - ROW_NUMBER()
  - NTILE()
  - SUM OVER()

---

## 🏁 Conclusion
This project demonstrates how SQL can be used to convert raw insurance data into actionable business insights. It covers customer segmentation, revenue analysis, risk detection, and profitability evaluation—core skills required for a data analyst role.

---

## 🚀 Tools Used
- MySQL
- SQL (Advanced Queries + Window Functions)

---

## 👤 Author
**Saurav Bhosale**  
Aspiring Data Analyst | SQL | Power BI 
