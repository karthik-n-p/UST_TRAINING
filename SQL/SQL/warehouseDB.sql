DECLARE @Databasename VARCHAR(128) = 'warehouseDB';

IF NOT EXISTS(SELECT 1 FROM sys.databases WHERE name = @Databasename)
BEGIN
	DECLARE @SQL NVARCHAR(MAX) = 'CREATE DATABASE ' + QUOTENAME(@Databasename);
	EXEC sp_executesql @SQL;
END

USE warehouseDB;

DROP TABLE [dbo].fmcg;

CREATE TABLE [dbo].fmcg (
    Ware_house_ID VARCHAR(20),
    WH_Manager_ID VARCHAR(20),
    Location_type VARCHAR(10),
    WH_capacity_size VARCHAR(10),
    zone VARCHAR(10),
    WH_regional_zone VARCHAR(10),
    num_refill_req_l3m INT,
    transport_issue_l1y INT,
    Competitor_in_mkt INT,
    retail_shop_num INT,
    wh_owner_type VARCHAR(15),
    distributor_num INT,
    flood_impacted INT,
    flood_proof INT,
    electric_supply INT,
    dist_from_hub INT,
    workers_num INT,
    wh_est_year INT,
    storage_issue_reported_l3m INT,
    temp_reg_mach INT,
    approved_wh_govt_certificate CHAR(20),
    wh_breakdown_l3m INT,
    govt_check_l3m INT,
    product_wg_ton INT
);


BULK INSERT [dbo].fmcg
FROM 'C:\Users\Administrator\Downloads\FMCG_data.csv'
WITH (
    FIELDTERMINATOR = ',',  -- Delimiter used in the CSV file
    ROWTERMINATOR = '\n',   -- End of line character
    FIRSTROW = 2            -- Skips the header row if present (use FIRSTROW = 1 if there's no header)
);


SELECT *
FROM fmcg;

-- 1. Shwo number of records
SELECT count(*) AS Num_of_records
FROM fmcg;

-- 2.Write a query to find warehouse with max capacity of storage
SELECT TOP(5) * 
FROM fmcg 
ORDER BY product_wg_ton DESC;

-- 3.Write a query to find warehouse with minimum capacity of storage
SELECT TOP(5) *
FROM fmcg 
ORDER BY product_wg_ton ASC;

-- 4. find min, avg, max, median distance from hub for
-- wearhouse with minimum capacity 10000 and regional type urban
SELECT WH_regional_zone, COUNT(*) as total_count
FROM fmcg
GROUP BY WH_regional_zone
ORDER BY WH_regional_zone;

-- 5. find min, avg, max, median distance from hub for
-- wearhouse with minimum capacity 10000 and regional type urban
WITH medianCTE AS (
	SELECT dist_from_hub, PERCENTILE_CONT(0.5) 
	WITHIN GROUP (ORDER BY dist_from_hub) OVER()
	AS Median_Price
	FROM fmcg
	WHERE Location_type = 'Urban' AND product_wg_ton >= 10000
)
SELECT *
FROM medianCTE;

WITH medianCTE AS (
	SELECT dist_from_hub, PERCENTILE_CONT(0.5) 
	WITHIN GROUP (ORDER BY dist_from_hub) OVER()
	AS Median_Price
	FROM fmcg
	WHERE Location_type = 'Urban' AND product_wg_ton >= 10000
)
SELECT 
	MAX(median_Price) AS median,
	MAX(dist_from_hub) AS maximum,
	MIN(dist_from_hub) AS minimum,
	AVG(dist_from_hub) AS average
FROM
	medianCTE;

-- 6. Window functions
--- in SQL window function performs calculations across set of table rows.
--- Unlike aggregate functions which returns a single value for a group of rows
---		window functions returns a value for each row, in result set.

-- RANK Function
SELECT TOP 5
	Ware_house_ID, 
	Location_type, 
	zone, 
	WH_owner_type, 
	product_wg_ton,
	Competitor_in_mkt,
	RANK() OVER(PARTITION BY Competitor_in_mkt ORDER BY product_wg_ton DESC) AS rank 
FROM 
	fmcg;

-- same values for same category returns same rank.
WITH cte AS (
SELECT
	Ware_house_ID, 
	Location_type, 
	WH_capacity_size,
	WH_regional_zone,
	workers_num,
	RANK() OVER(PARTITION BY WH_regional_zone ORDER BY workers_num DESC) AS rank 
FROM
	fmcg
)
SELECT *
FROM cte;

-- dense rank
WITH cte AS (
SELECT
	Ware_house_ID, 
	Location_type, 
	WH_capacity_size,
	WH_regional_zone,
	workers_num,
	DENSE_RANK() OVER(PARTITION BY WH_regional_zone ORDER BY workers_num DESC) AS rank 
FROM
	fmcg
)
SELECT TOP 5 * 
FROM cte;

-- top 5 of each of regional zone 
-- using cte
WITH regional_table AS (
SELECT
	Ware_house_ID, 
	Location_type, 
	WH_capacity_size,
		WH_regional_zone,
		workers_num,
		DENSE_RANK() OVER(PARTITION BY WH_regional_zone ORDER BY workers_num DESC) AS WH_rank 
	FROM
		fmcg
)
SELECT *
FROM regional_table
WHERE WH_rank <= 5;


-- with subqueries
SELECT * 

SELECT * 
FROM(
	SELECT
	Ware_house_ID,
	Location_type,
	zone,
	distributor_num,
	retail_shop_num,
	DENSE_RANK() OVER(PARTITION BY zone ORDER BY retail_shop_num ASC) AS WH_RANK FROM fmcg)
	AS warehouses
WHERE
	WH_RANK <=5;


-- top 5 rows
SELECT *
FROM(
	SELECT  TOP 5 
	Ware_house_ID,
	Location_type,
	zone,
	distributor_num,
	retail_shop_num,
	DENSE_RANK() OVER(PARTITION BY zone ORDER BY retail_shop_num ASC) AS WH_RANK FROM fmcg)
	AS warehouses


-- LAG and LEAD 
SELECT
	Ware_house_ID, 
	Location_type, 
	zone, 
	workers_num, 
	product_wg_ton,
	LAG(product_wg_ton, 1) OVER(PARTITION BY zone ORDER BY workers_num DESC)
	AS previous_product_wg_ton 
FROM 
	fmcg;

---

SELECT
	Ware_house_ID, 
	Location_type, 
	zone, 
	workers_num, 
	product_wg_ton,
	LEAD(product_wg_ton, 1) OVER(PARTITION BY zone ORDER BY workers_num DESC)
	AS next_product_wg_ton 
FROM 
	fmcg;

----

SELECT
	Ware_house_ID, 
	Location_type, 
	zone, 
	workers_num, 
	product_wg_ton - LEAD(product_wg_ton, 1) OVER(PARTITION BY zone ORDER BY workers_num DESC)
	AS difference_in_wg
FROM 
	fmcg;

-- ENTAIL
---- Returns percentiles after dividing
SELECT
	Ware_house_ID, 
	Location_type, 
	zone, 
	workers_num,
	product_wg_ton,
	NTILE(4) OVER(ORDER BY product_wg_ton ASC)
	AS Quartiles
FROM 
	fmcg;

----

SELECT
	Ware_house_ID, 
	Location_type, 
	zone, 
	workers_num,
	product_wg_ton,
	PERCENT_RANK() OVER(ORDER BY product_wg_ton ASC) * 100
	AS percentile
FROM 
	fmcg;


-- show all records where no. of workers comes in range (0th to 40th percentile)
SELECT * 
FROM(
	SELECT
		Ware_house_ID, 
		Location_type, 
		zone, 
		workers_num,
		product_wg_ton,
		PERCENT_RANK() OVER(ORDER BY workers_num ASC) * 100
		AS percentile
	FROM 
		fmcg
	) AS _
WHERE
	percentile <=40;

-- find the difference between current value of product wg ton and compare it with previous two values 
-- and rank it according to difference

WITH td AS (
SELECT
	Ware_house_ID, 
	product_wg_ton,
	LAG(product_wg_ton, 2) OVER(ORDER BY product_wg_ton ASC) AS pre_2_wg_ton,
	product_wg_ton - LAG(product_wg_ton, 2) OVER(ORDER BY product_wg_ton ASC)
	AS difference_with_pre_2
FROM 
	fmcg
)
SELECT
	*,
	DENSE_RANK() OVER(ORDER BY difference_with_pre_2 DESC) AS rank
FROM 
	td;

-- using sub query
SELECT
	*,
	DENSE_RANK() OVER(ORDER BY difference_with_pre_2 DESC) AS rank
FROM 
	(
SELECT
	Ware_house_ID, 
	product_wg_ton,
	LAG(product_wg_ton, 2) OVER(ORDER BY product_wg_ton ASC) AS pre_2_wg_ton,
	product_wg_ton - LAG(product_wg_ton, 2) OVER(ORDER BY product_wg_ton ASC)
	AS difference_with_pre_2
FROM 
	fmcg
) AS td;