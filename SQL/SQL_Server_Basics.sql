-- T-SQL trasacy=t sql which is an extension of structured query language.
-- T-SQL Developed by Microsoft for use of SQL Server, Azure SQL DB.
-- Key features of T-SQL:
---- a. variables
---- b. conrol flow statements (IF-ELSE, loops etc)
---- c. try catch
---- d. create functions
---- e. stored procedures

-- 1. Display the list of databases
SELECT name FROM sys.databases;

-- 2. Display the list of schema
SELECT name AS SchemaName FROM sys.schemas;

-- 3. Create new database
CREATE DATABASE Sales;

-- 4. declare a variable name Databasename
DECLARE @Databasename VARCHAR(128) = 'Sales';

-- 5. test condition to check if database exists
IF NOT EXISTS(SELECT 1 FROM sys.databases WHERE name = @Databasename)
BEGIN
	DECLARE @SQL NVARCHAR(MAX) = 'CREATE DATABASE ' + QUOTENAME(@Databasename);
	EXEC sp_executesql @SQL;
END

-- 6. use the database
USE Sales;

-- delete table if it already exists
IF OBJECT_ID('dbo.products', 'U') IS NOT NULL
DROP TABLE dbo.products;


-- 7. create a table products
CREATE TABLE [dbo].products(productid VARCHAR(20), 
							productname VARCHAR(50),
							price FLOAT, quantity INT, 
							storename VARCHAR(50), 
							city VARCHAR(15))

-- 8. Insert additional sample data into the products table
INSERT INTO [dbo].products (productid, productname, price, quantity, storename, city) VALUES
('E001', 'Smartphone', 25000.00, 30, 'Tech World', 'Mumbai'),
('E002', 'Laptop', 60000.00, 20, 'ElectroMart', 'Delhi'),
('E003', 'Smart TV', 45000.00, 15, 'Gadget Hub', 'Bengaluru'),
('E004', 'Bluetooth Headphones', 3000.00, 50, 'SoundZone', 'Chennai'),
('E005', 'Tablet', 20000.00, 25, 'Digital Electronics', 'Hyderabad'),
('E006', 'Smartwatch', 8000.00, 40, 'Wearable Wonders', 'Pune'),
('E007', 'Camera', 35000.00, 10, 'PhotoGear', 'Kolkata'),
('E008', 'External Hard Drive', 6000.00, 35, 'Data Storage Solutions', 'Ahmedabad'),
('E009', 'Printer', 12000.00, 18, 'Print Hub', 'Jaipur'),
('E010', 'Home Theater System', 70000.00, 8, 'Entertainment Central', 'Chandigarh');


-- 9. display the inserted products
SELECT *
FROM [dbo].products;

-- 10. display the table schema
SELECT
	TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM
	INFORMATION_SCHEMA.COLUMNS
WHERE
	TABLE_NAME = 'products';

-- 12. alter the table, add a new column
ALTER TABLE [dbo].products
ADD totalamount FLOAT;

-- 14. update column datatype
ALTER TABLE [dbo].products
ALTER COLUMN totalamount DECIMAL(18, 2);

-- 15. update the value of column total amount 
UPDATE [dbo].products
SET totalamount = price * quantity;

-- 16. query to show first 5 records
SELECT TOP (5) [productid]
      ,[productname]
      ,[price]
      ,[quantity]
      ,[storename]
      ,[city]
      ,[totalamount]
  FROM [Sales].[dbo].[products]

-- 11. delete the table
DROP TABLE [dbo].products;