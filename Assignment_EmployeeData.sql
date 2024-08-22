-- Create the database
CREATE DATABASE HREmployeeDB;
USE HREmployeeDB;

-- Drop the table if it already exists
IF OBJECT_ID('EmployeeData', 'U') IS NOT NULL
    DROP TABLE EmployeeData;

-- Create the EmployeeData table
CREATE TABLE EmployeeData (
    Attrition NVARCHAR(50),
    BusinessTravel NVARCHAR(50),
    CF_age_band NVARCHAR(50),
    CF_attrition_label NVARCHAR(50),
    Department NVARCHAR(50),
    EducationField NVARCHAR(50),
    emp_no NVARCHAR(50),
    EmployeeNumber INT,
    Gender NVARCHAR(50),
    JobRole NVARCHAR(50),
    MaritalStatus NVARCHAR(50),
    OverTime NVARCHAR(50),
    Over18 NVARCHAR(50),
    TrainingTimesLastYear INT,
    Age INT,
    CF_current NVARCHAR(50),
    DailyRate INT,
    DistanceFromHome INT,
    Education NVARCHAR(50),
    EmployeeCount INT,
    EnvironmentSatisfaction INT,
    HourlyRate INT,
    JobInvolvement INT,
    JobLevel INT,
    JobSatisfaction INT,
    MonthlyIncome INT,
    MonthlyRate INT,
    NumCompaniesWorked INT,
    PercentSalaryHike INT,
    PerformanceRating INT,
    RelationshipSatisfaction INT,
    StandardHours INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    WorkLifeBalance INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT
);

-- Bulk insert data into the table
BULK INSERT EmployeeData
FROM 'C:\Users\Administrator\Downloads\HR_Employee1.csv'
WITH
(
    FIELDTERMINATOR = ',',  -- Delimiter for fields
    ROWTERMINATOR = '0x0a', -- End of each row
    FIRSTROW = 2            -- Skip header row
);

-- a. Return the shape of the table
-- Number of rows and columns
SELECT 
    (SELECT COUNT(*) FROM EmployeeData) AS row_no,
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EmployeeData') AS no_columns;

-- b. Calculate the cumulative sum of total working years for each department
SELECT 
    Department,
    TotalWorkingYears,
    SUM(TotalWorkingYears) OVER (PARTITION BY Department ORDER BY TotalWorkingYears ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumulative_sum_year
FROM EmployeeData;

-- c. Which Gender Has Higher Strength as Workforce in Each Department
select * from EmployeeData

WITH GenderCounts AS (
    SELECT 
        Department,
        Gender,
        COUNT(*) AS Gender_Count
    FROM EmployeeData
    GROUP BY Department, Gender
),
GenderSummary AS (
    SELECT 
        Department,
        MAX(CASE WHEN Gender = 'Male' THEN Gender_Count ELSE 0 END) AS Male_Count,
        MAX(CASE WHEN Gender = 'Female' THEN Gender_Count ELSE 0 END) AS Female_Count
    FROM GenderCounts
    GROUP BY Department
),
GenderWithHighestCount AS (
    SELECT 
        Department,
        CASE 
            WHEN Male_Count > Female_Count THEN 'Male'
            WHEN Female_Count > Male_Count THEN 'Female'
            ELSE 'Equal' -- In case of a tie
        END AS Gender_With_Highest_Count
    FROM GenderSummary
)
SELECT 
    S.Department,
    S.Male_Count,
    S.Female_Count,
    G.Gender_With_Highest_Count
FROM GenderSummary S
JOIN GenderWithHighestCount G
    ON S.Department = G.Department;

-- Alternative answer

Select Department,
	Gender,
	Count(*) as gender_count ,
	Rank() over(partition by Department order by Count(*) desc) as Gender_rank 
	from EmployeeData group by Department,Gender
	order by Department,COUNT(*) desc



-- d. Create a New Column `AGE_BAND` and Show Distribution of Employee's Age Band Group
ALTER TABLE EmployeeData
ADD AGE_BAND INT;

UPDATE EmployeeData
SET AGE_BAND = (
    SELECT COUNT(*)
    FROM EmployeeData AS ed2
    WHERE ed2.CF_age_band = EmployeeData.CF_age_band
)
select CF_age_band,AGE_BAND from EmployeeData

-- e. Compare All Marital Status of Employees and Find the Most Frequent Marital Status
-- Query to get marital status count and frequency rank
SELECT 
	Top(1)
    MaritalStatus,
    Marital_Status_Count,
    RANK() OVER (ORDER BY Marital_Status_Count DESC) AS Freq_Rank
FROM (
    SELECT 
        MaritalStatus, 
        COUNT(*) AS Marital_Status_Count
    FROM EmployeeData
    GROUP BY MaritalStatus
) A






-- f. Show the Job Role with Highest Attrition Rate (Percentage)

WITH AttritionRate AS (
    SELECT 
        JobRole,
        CAST((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS decimal) AS Attrition_Percentage
    FROM EmployeeData
    GROUP BY JobRole
)
SELECT 
    JobRole,
	Atrrition_Rate =(SELECT MAX(Attrition_Percentage) FROM AttritionRate)
FROM AttritionRate
WHERE Attrition_Percentage = (SELECT MAX(Attrition_Percentage) FROM AttritionRate);


-- g. Show Distribution of Employee's Promotion, Find the Maximum Chances of Employee Getting Promoted


SELECT
	Department,
    CASE
        WHEN YearsSinceLastPromotion = 0 THEN 'Recently Promoted'
        ELSE 'Not Recently Promoted'
    END AS PromotionStatus,
    COUNT(EmployeeNumber) AS NumberOfEmployees,
    AVG(PerformanceRating) AS AvgPerformanceRating,
    AVG(JobInvolvement) AS AvgJobInvolvement,
    AVG(YearsInCurrentRole) AS AvgYearsInCurrentRole,
    AVG(YearsAtCompany) AS AvgYearsAtCompany,
    AVG(TrainingTimesLastYear) AS AvgTrainingTimesLastYear,
    AVG(Age) AS AvgAge,
  
    AVG(JobSatisfaction) AS AvgJobSatisfaction,
    AVG(MonthlyIncome) AS AvgMonthlyIncome,
    AVG(NumCompaniesWorked) AS AvgNumCompaniesWorked,
   
    AVG(YearsWithCurrManager) AS AvgYearsWithCurrManager
FROM
    EmployeeData
WHERE
    Attrition = 'No'
GROUP BY
Department,
    CASE
        WHEN YearsSinceLastPromotion = 0 THEN 'Recently Promoted'
        ELSE 'Not Recently Promoted'
    END;


-- Fewer Years in Current Role: Recently promoted employees have fewer years in their current role compared to those not recently promoted, across all departments.

-- Higher Income for Not Promoted: Employees not recently promoted generally have higher average monthly incomes than those recently promoted.

-- Similar Job Involvement: The average job involvement is consistent between recently promoted and not recently promoted employees in all departments.

-- Average Age Difference: Recently promoted employees tend to be younger than those not recently promoted, regardless of department.





-- h. Show the Cumulative Sum of Total Working Years for Each Department
-- (Duplicate of query b)

-- i. Find the Rank of Employees Within Each Department Based on Their Monthly Income
SELECT 
    EmployeeNumber,
    Department,
    MonthlyIncome,
    DENSE_RANK() OVER (PARTITION BY Department ORDER BY MonthlyIncome DESC) AS Income_Rank
FROM EmployeeData;

-- J. Calculate the Running Total of 'Total Working Years' for Each Employee Within Each Department and Age Band
SELECT 
    EmployeeNumber,
    Department,
    CF_age_band,
    TotalWorkingYears,
    SUM(TotalWorkingYears) 
	OVER (PARTITION BY Department, CF_AGE_BAND ORDER BY TotalWorkingYears ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
	AS Running_Total_Working_Years
FROM EmployeeData;

-- K. For Each Employee Who Left, Calculate the Number of Years They Worked Before Leaving and Compare It with the Average Years Worked by Employees in the Same Department
WITH YearsWorked AS (
    SELECT 
        EmployeeNumber,
        Department,
        YearsAtCompany,
        CASE 
            WHEN Attrition = 'Yes' THEN YearsAtCompany
            ELSE NULL
        END AS Years_Worked_Before_Leaving
    FROM EmployeeData
),
AvgYears AS (
    SELECT 
        Department,
        AVG(YearsAtCompany) AS Avg_Years_Worked
    FROM EmployeeData
    GROUP BY Department
)
SELECT 
    Y.EmployeeNumber,
    Y.Department,
    Y.Years_Worked_Before_Leaving,
    A.Avg_Years_Worked
FROM YearsWorked Y
JOIN AvgYears A
    ON Y.Department = A.Department
WHERE Y.Years_Worked_Before_Leaving IS NOT NULL order by EmployeeNumber;

-- Findings 
-- R&D employees often have shorter tenures before leaving compared to Sales, with fewer years worked on average.
-- HR employees tend to stay longer before leaving compared to R&D and Sales, with a higher average tenure.
-- Sales employees generally have longer tenures, with more consistent average years worked before leaving.



select * from EmployeeData
-- l. Rank the Departments by the Average Monthly Income of Employees Who Have Left
SELECT Department,
	Mi as Monthly_Income,
	Rank() over(order by a.Mi desc) as Monthly_Income_Ranking
	FROM (SELECT Department, 
	AVG(MonthlyIncome) as Mi
	FROM EmployeeData WHERE Attrition='Yes' group by Department) a





-- m. Find If There Is Any Relation Between Attrition Rate and Marital Status of Employee

    SELECT 
        MaritalStatus,
        (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS Attrition_Percentage
    FROM EmployeeData GROUP BY MaritalStatus
	-- singles tend to leave the company more than other category and married people tend to stay in the company more than others

-- n. Show the Department with Highest Attrition Rate (Percentage)
SELECT top(1) Department,
        (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS Attrition_Percentage
    FROM EmployeeData
    GROUP BY Department order by Attrition_Percentage desc


-- o. Calculate the Moving Average of Monthly Income Over the Past 3 Employees for Each Job Role
    SELECT 
        JobRole,
        EmployeeNumber,
        MonthlyIncome,
        AVG(MonthlyIncome) OVER (PARTITION BY JobRole ORDER BY EmployeeNumber ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Moving_Avg_Income
    FROM EmployeeData


--p) Identify employees with outliers in monthly income within each job role. [ Condition :
-- Monthly_Income < Q1 - (Q3 - Q1) * 1.5 OR Monthly_Income > Q3 + (Q3 - Q1) ]
WITH IncomeStats AS (
    SELECT 
        JobRole,
        EmployeeNumber,
        MonthlyIncome,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY MonthlyIncome) OVER (PARTITION BY JobRole) AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY MonthlyIncome) OVER (PARTITION BY JobRole) AS Q3
    FROM EmployeeData
)
SELECT
    EmployeeNumber,
    JobRole,
    MonthlyIncome,
    CASE
        WHEN MonthlyIncome < Q1 - (Q3 - Q1) * 1.5 THEN 'Low'
        WHEN MonthlyIncome > Q3 + (Q3 - Q1) * 1.5 THEN 'High'
        ELSE 'Not an Outlier'
    END AS OutlierType
FROM IncomeStats
WHERE MonthlyIncome < Q1 - (Q3 - Q1) * 1.5
   OR MonthlyIncome > Q3 + (Q3 - Q1) * 1.5;



-- q. Gender Distribution Within Each Job Role, Show Each Job Role with Its Gender Domination
WITH GenderCount AS (
    SELECT 
        JobRole,
        Gender,
        COUNT(*) AS Gender_Count
    FROM EmployeeData
    GROUP BY JobRole, Gender
),
MaxGender AS (
    SELECT 
        JobRole,
        MAX(Gender_Count) AS Max_Count
    FROM GenderCount
    GROUP BY JobRole
)
SELECT 
    G.JobRole,
    G.Gender,
    G.Gender_Count,
    CASE 
        WHEN G.Gender_Count = M.Max_Count THEN 
            CASE 
                WHEN G.Gender = 'Male' THEN 'Male_Domination'
                WHEN G.Gender = 'Female' THEN 'Female_Domination'
                ELSE 'No_Domination'
            END
        ELSE 'No_Domination'
    END AS Gender_Domination
FROM GenderCount G
JOIN MaxGender M
    ON G.JobRole = M.JobRole AND G.Gender_Count = M.Max_Count;

-- r. Percent Rank of Employees Based on Training Times Last Year
SELECT 
    EmployeeNumber,
    TrainingTimesLastYear,
    PERCENT_RANK() OVER (ORDER BY TrainingTimesLastYear) AS Percent_Rank
FROM EmployeeData;

-- s. Divide Employees into 5 Groups Based on Training Times Last Year
SELECT 
    EmployeeNumber,
    TrainingTimesLastYear,
    NTILE(5) OVER (ORDER BY TrainingTimesLastYear) AS Training_Group
FROM EmployeeData;

-- t. Categorize Employees Based on Training Times Last Year as - Frequent Trainee, Moderate Trainee, Infrequent Trainee

--Trainee, Infrequent Trainee
SELECT emp_no,TrainingTimesLastYear,
CASE
        WHEN TrainingTimesLastYear > 4 THEN 'Frequent Trainee'
        WHEN TrainingTimesLastYear > 2 THEN 'Moderate Trainee'
        ELSE 'Infrequent Trainee'
END AS 'Training Frequency'
FROM EmployeeData
ORDER BY TrainingTimesLastYear DESC


-- u. Categorize Employees as 'High', 'Medium', or 'Low' Performers Based on Their Performance Rating
SELECT 
    EmployeeNumber,
    PerformanceRating,
    CASE 
        WHEN PerformanceRating >= 4 THEN 'High'
        WHEN PerformanceRating = 3 THEN 'Medium'
        ELSE 'Low'
    END AS Performance_Category
FROM EmployeeData;

-- v. Use a CASE WHEN Statement to Categorize Employees into 'Poor', 'Fair', 'Good', or 'Excellent' Work-Life Balance Based on Their Work-Life Balance Score
SELECT * from EmployeeData
select
    EmployeeNumber,
    WorkLifeBalance,
    CASE 
        WHEN WorkLifeBalance = 1 THEN 'Poor'
        WHEN WorkLifeBalance = 2 THEN 'Fair'
        WHEN WorkLifeBalance = 3 THEN 'Good'
        ELSE 'Excellent'
    END AS Work_Life_Balance_Category
FROM EmployeeData;

-- w. Group Employees into 3 Groups Based on Their Stock Option Level Using the [NTILE] Function
SELECT 
    EmployeeNumber,
    StockOptionLevel,
    NTILE(3) OVER (ORDER BY StockOptionLevel) AS StockOption_Group
FROM EmployeeData;

-- x. Find Key Reasons for Attrition in Company

SELECT 
	 Department,
    EducationField,
    Gender,
    JobRole,
    MaritalStatus,
    OverTime,
    COUNT(*) AS AttritionCount,
    ROUND(AVG(Age), 2) AS AvgAgeAttrition,
    ROUND(AVG(MonthlyIncome), 2) AS AvgMonthlyIncomeAttrition,
    ROUND(AVG(YearsAtCompany), 2) AS AvgYearsAtCompany,
    ROUND(AVG(DistanceFromHome), 2) AS AvgDistanceFromHome,
    ROUND(AVG(JobSatisfaction), 2) AS AvgJobSatisfaction,
    ROUND(AVG(WorkLifeBalance), 2) AS AvgWorkLifeBalance,
    ROUND(AVG(EnvironmentSatisfaction), 2) AS AvgEnvironmentSatisfaction,
    ROUND(AVG(JobInvolvement), 2) AS AvgJobInvolvement,
    ROUND(AVG(YearsSinceLastPromotion), 2) AS AvgYearsSinceLastPromotion
   
FROM 
    EmployeeData
WHERE 
    Attrition = 'Yes'
GROUP BY 
    Department,
    EducationField,
    Gender,
    JobRole,
    MaritalStatus,
    OverTime
ORDER BY 
    AttritionCount DESC;

-- Findings 
-- Sales and R&D departments have the highest attrition rates.
-- Sales Executives and Research Scientists are the most affected job roles.
-- Single(marital status) employees have a higher likelihood of leaving.
-- Overtime is a significant factor contributing to higher attrition.
-- Younger employees are more likely to leave.
-- Employees with less experience tend to leave more frequently.


