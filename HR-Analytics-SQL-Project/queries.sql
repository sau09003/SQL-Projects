create database HRAnalyticsDB;
use HRAnalyticsDB;
rename table `hr-employee-attrition` to `EmployeeData`;
-- Beginner Level
-- Display all employee records.
select * from employeedata;

-- Show only employee names/IDs and departments.
select employeenumber, department from employeedata;

-- Count the total number of employees.
select count(distinct employeenumber) as Total_Number_Emp from employeedata;

-- Count the number of male and female employees.
select count(distinct employeenumber) as Count_Of_Emp , gender  from employeedata group by Gender;

-- Find the average age of employees.
select ROUND(AVG(Age),2) as AverageAge from employeedata;

-- Find the youngest and oldest employee.
SELECT
    MIN(Age) AS YoungestEmp,
    MAX(Age) AS OldestEmp
FROM EmployeeData;

SELECT *
FROM EmployeeData
WHERE Age = (SELECT MIN(Age) FROM EmployeeData)
   OR Age = (SELECT MAX(Age) FROM EmployeeData);

-- List all unique departments.
select distinct(department) as Departments from employeedata; 

-- List all unique job roles.
select distinct(JobRole) as JobRoles from employeedata; 

-- Count employees in each department.
select count(distinct employeenumber) as Count_of_Emp , department from employeedata group by Department;

-- Count employees in each job role.
select count(distinct employeenumber) as Count_of_Emp , JobRole from employeedata group by JobRole;

-- Intermediate Level

-- How many employees have left the company (Attrition = 'Yes')?
select count(employeenumber) as Count_of_Left_company from employeedata where Attrition ='yes'; 

-- Calculate the employee attrition rate.
select (select count(employeenumber) as Count_of_Left_company from employeedata where Attrition ='yes') / count(distinct employeenumber) * 100   as Attrition_rate from employeedata;
 SELECT
ROUND(
COUNT(CASE WHEN Attrition='Yes' THEN 1 END)
*100.0/COUNT(*),2
) AS AttritionRate
FROM EmployeeData;
 
-- Which department has the highest attrition?
select count(employeenumber) as Count_of_Left_company, department from employeedata where Attrition ='yes' group by department order by Count_of_Left_company desc limit 1; 

-- Which job role has the highest attrition?
select count(employeenumber) as Count_of_Left_company, JobRole from employeedata where Attrition ='yes' group by JobRole order by Count_of_Left_company desc limit 1; 

-- Find the average monthly income by department.
select round(avg(monthlyincome),2) as Avg_MonthlyIncome, department from employeedata group by Department;

-- Find the average monthly income by job role.
select round(avg(monthlyincome),2) as Avg_MonthlyIncome, JobRole from employeedata group by JobRole;

-- Which department pays the highest average salary?
select round(avg(monthlyincome),2) as Avg_MonthlyIncome, department from employeedata group by Department order by Avg_MonthlyIncome desc limit 1; 

-- Find the top 10 highest-paid employees.
select EmployeeNumber, (monthlyincome) as MonthlyIncome  from employeedata  order by MonthlyIncome desc limit 10; 

-- Find employees earning more than the company average salary.
select EmployeeNumber, (monthlyincome) as MonthlyIncome  from employeedata  where MonthlyIncome > (select avg(monthlyincome) from employeedata); 

-- Count employees by marital status.
SELECT
    MaritalStatus,
    COUNT(*) AS EmployeeCount
FROM EmployeeData
GROUP BY MaritalStatus;

-- Count employees by education level.
select count(distinct employeenumber) , education from employeedata group by Education;

-- Count employees by education field.
select count(distinct employeenumber) , Educationfield from employeedata group by EducationField;

-- Find the average age for each department.
select round( avg(age),2) as Avg_Age, department from employeedata group by Department;

-- Find the average years at the company by department.
SELECT
    Department,
    ROUND(AVG(YearsAtCompany),2) AS AvgYearsAtCompany
FROM EmployeeData
GROUP BY Department;

-- Which department has the most experienced employees?
SELECT
    Department,
    ROUND(AVG(TotalWorkingYears),2) AS AvgExperience
FROM EmployeeData
GROUP BY Department
ORDER BY AvgExperience DESC
LIMIT 1;

-- Find employees who work overtime.
select * from employeedata where OverTime= 'yes';

-- Compare attrition between employees who work overtime and those who do not.
select count(distinct employeenumber) as Count_Emp, OverTime from employeedata where Attrition='yes' group by OverTime ;

-- Find the average work-life balance by department.
select round(avg(WorkLifeBalance),2) as Avg_WorkLifeBalance, department from employeedata group by Department ;

-- Find the average job satisfaction by department.
select round(avg(jobsatisfaction),2) as Avg_JobSatisfaction, department from employeedata group by Department ;

-- Find employees who have never been promoted.
select * from employeedata where YearsSinceLastPromotion = 0;

-- Advanced Level

-- Rank employees by monthly income.
select employeenumber , monthlyincome, rank() over (order by monthlyincome desc) as employee_monthlySalary_Rank from employeedata;

-- Find the top 3 highest-paid employees in each department.
SELECT EmployeeNumber,
       Department,
       MonthlyIncome
FROM (
    SELECT EmployeeNumber,
           Department,
           MonthlyIncome,
           rank () OVER (
               PARTITION BY Department
               ORDER BY MonthlyIncome DESC
           ) AS rn
    FROM employeedata
) t
WHERE rn <= 3
ORDER BY Department, rn;

-- Find employees whose salary is above their department's average salary.
SELECT EmployeeNumber,
       Department,
       MonthlyIncome
FROM (
    SELECT EmployeeNumber,
           Department,
           MonthlyIncome,
           AVG(MonthlyIncome) OVER (
               PARTITION BY Department
           ) AS dept_avg
    FROM employeedata
) t
WHERE MonthlyIncome > dept_avg;

-- or 
SELECT EmployeeNumber,
       Department,
       MonthlyIncome
FROM employeedata e
WHERE MonthlyIncome >
(
    SELECT AVG(MonthlyIncome)
    FROM employeedata
    WHERE Department = e.Department
);

-- Calculate the running total of monthly income by department.
select 
employeenumber,
 monthlyincome, 
 department ,
 sum(monthlyincome) over (
 partition by department order by employeenumber ) as Running_Total
 from employeedata 
 order by Department, EmployeeNumber;

-- Find the employee with the highest salary in each department.
SELECT EmployeeNumber,
       MonthlyIncome,
       Department
FROM (
    SELECT EmployeeNumber,
           MonthlyIncome,
           Department,
           ROW_NUMBER() OVER (
               PARTITION BY Department
               ORDER BY MonthlyIncome DESC
           ) AS rn
    FROM employeedata
) t
WHERE rn = 1;

-- Find employees with more than 10 years of experience.
select employeenumber, totalWorkingYears from employeedata where TotalWorkingYears > 10;

-- Find employees who have worked with the same manager for more than 5 years.
select employeenumber, yearswithcurrmanager from employeedata where YearsWithCurrManager > 5;

-- Which education field has the highest average salary?
select round(avg(MonthlyIncome),2) as Avg_Mon_Salary, educationfield from employeedata group by EducationField order by Avg_Mon_Salary desc limit 1;

-- Which job level has the highest average performance rating?
select round(avg(PerformanceRating),2) as Avg_PerformanceRate, JobLevel from employeedata group by JobLevel order by Avg_PerformanceRate desc limit 1;

-- Find the average salary hike for each department.
select round(avg(PercentSalaryHike), 2) as Avg_PercentSalaryHike, Department from employeedata group by Department ;

-- Compare average salaries of employees who left versus those who stayed.
select round(avg(monthlyIncome),2) as Avg_Salary, Attrition from employeedata group by Attrition;

-- Find employees with high performance ratings but low job satisfaction.
SELECT EmployeeNumber,
       PerformanceRating,
       JobSatisfaction
FROM employeedata
WHERE PerformanceRating >= 4
  AND JobSatisfaction <= 2;

-- Identify employees who may be at risk of leaving (for example, those with overtime, low work-life balance, and low job satisfaction).
select EmployeeNumber from employeedata where OverTime ='yes' and WorkLifeBalance <=2 and JobSatisfaction <=2;

-- Create a view showing employee salary details.
CREATE VIEW salary_details1 AS 
SELECT EmployeeNumber,
       Department,
       MonthlyIncome,
       MonthlyIncome * 12 AS AnnualIncome
FROM employeedata;
select * from salary_details1;

-- Find the percentage of employees in each department.
select department, count(*) as employee_count, round(count(*) *100.0 / sum(count(*)) over (),2) as percentage from employeedata group by Department;

-- Find the percentage of employees who work overtime.
select OverTime, count(*) as employee_count, round(count(*) *100.0 / sum(count(*)) over (),2) as percentage from employeedata group by OverTime;

-- Calculate the average salary for each gender.
select  gender, round(avg(monthlyincome),2) as Avg_Income  from employeedata group by Gender;

-- Find the department with the highest average years at the company.
select department , round(avg(yearsatcompany),2) as Highest_At_Company from employeedata group by Department order by Highest_At_Company desc limit 1;

-- Expert (Portfolio-Level) Questions

-- Which factors appear most associated with attrition?
SELECT
    OverTime,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS EmployeesLeft,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS AttritionRate
FROM employeedata
GROUP BY OverTime;

SELECT
    JobSatisfaction,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS EmployeesLeft,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS AttritionRate
FROM employeedata
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;

-- Does overtime affect employee attrition?
SELECT
    OverTime,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS EmployeesLeft,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS AttritionRate
FROM employeedata
GROUP BY OverTime;

-- Does work-life balance influence attrition?
SELECT
    WorkLifeBalance,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS EmployeesLeft,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS AttritionRate
FROM employeedata
GROUP BY WorkLifeBalance;

-- Does monthly income affect employee retention?
SELECT
    Attrition,
    COUNT(*) AS TotalEmployees,
    ROUND(AVG(MonthlyIncome), 2) AS AvgMonthlyIncome
FROM employeedata
GROUP BY Attrition;

-- Which department should HR focus on to reduce attrition?
SELECT
    Department,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS EmployeesLeft,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS AttritionRate
FROM employeedata
GROUP BY Department order by AttritionRate desc limit 1;

-- Which job role has the highest employee turnover?
SELECT
    JobRole,
    COUNT(*) AS EmployeesLeft
FROM employeedata
WHERE Attrition = 'Yes'
GROUP BY JobRole
ORDER BY EmployeesLeft DESC
LIMIT 1;

-- Build an employee retention report using SQL.
SELECT
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS RetainedEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS EmployeesLeft,
    ROUND(
        SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS RetentionRate,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS TurnoverRate,
    ROUND(AVG(MonthlyIncome), 2) AS AvgMonthlyIncome,
    ROUND(AVG(YearsAtCompany), 2) AS AvgYearsAtCompany
FROM employeedata;

-- Build an HR dashboard data source using SQL views.
CREATE VIEW employee_summary AS
SELECT
    EmployeeNumber,
    Department,
    JobRole,
    Gender,
    Age,
    MonthlyIncome,
    YearsAtCompany,
    TotalWorkingYears,
    Attrition,
    OverTime,
    JobSatisfaction,
    WorkLifeBalance,
    PerformanceRating
FROM employeedata;
select * from employee_summary;

CREATE VIEW department_dashboard AS
SELECT
    Department,
    COUNT(*) AS TotalEmployees,
    ROUND(AVG(MonthlyIncome),2) AS AvgSalary,
    ROUND(AVG(YearsAtCompany),2) AS AvgYearsAtCompany,
    SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS EmployeesLeft,
    ROUND(
        SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS AttritionRate
FROM employeedata
GROUP BY Department;
select * from department_dashboard;

CREATE VIEW jobrole_dashboard AS
SELECT
    JobRole,
    COUNT(*) AS TotalEmployees,
    ROUND(AVG(MonthlyIncome),2) AS AvgSalary,
    SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS EmployeesLeft,
    ROUND(
        SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS AttritionRate
FROM employeedata
GROUP BY JobRole;
select * from jobrole_dashboard;

-- Create a SQL report combining salary, satisfaction, performance, and attrition insights.
SELECT
    Department,
    JobRole,

    COUNT(*) AS TotalEmployees,

    ROUND(AVG(MonthlyIncome), 2) AS AvgSalary,
    ROUND(AVG(JobSatisfaction), 2) AS AvgJobSatisfaction,
    ROUND(AVG(WorkLifeBalance), 2) AS AvgWorkLifeBalance,
    ROUND(AVG(PerformanceRating), 2) AS AvgPerformanceRating,

    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS EmployeesLeft,

    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS AttritionRate,

    ROUND(AVG(YearsAtCompany), 2) AS AvgTenure

FROM employeedata
GROUP BY Department, JobRole
ORDER BY AttritionRate DESC;