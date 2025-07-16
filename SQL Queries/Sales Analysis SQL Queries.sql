-- 1. Check for Null or Missing Values
SELECT * FROM [US Superstore data] WHERE Sales IS NULL OR Profit IS NULL;

-- 2. Remove Duplicate Rows
SELECT Order_ID, COUNT(*) FROM [US Superstore data]
GROUP BY Order_ID
HAVING COUNT(*) > 1;

-- 3. Sales & Profit Summary by Region
SELECT Region, 
       SUM(Sales) AS TotalSales, 
       SUM(Profit) AS TotalProfit, 
       ROUND(SUM(Profit)*100.0 / NULLIF(SUM(Sales),0), 2) AS ProfitMargin
FROM [US Superstore data]
GROUP BY Region
ORDER BY TotalProfit DESC;

-- 4. Profit Opportunity Analysis
-- Identify top categories in West region with highest profit potential
SELECT Category, 
       Sub_Category, 
       SUM(Sales) AS Sales, 
       SUM(Profit) AS Profit
FROM [US Superstore data]
WHERE Region = 'West'
GROUP BY Category, Sub_Category
HAVING SUM(Profit) > 0
ORDER BY Profit DESC;

-- 5.Top 10 Products by Sales
SELECT TOP 10 Product_Name, SUM(Sales) AS TotalSales
FROM [US Superstore data]
GROUP BY Product_Name
ORDER BY TotalSales DESC;

-- 6.Monthly Trend:
SELECT FORMAT(Order_Date, 'yyyy-MM') AS Month,
       SUM(Sales) AS MonthlySales,
       SUM(Profit) AS MonthlyProfit
FROM [US Superstore data]
GROUP BY FORMAT(Order_Date, 'yyyy-MM')
ORDER BY Month;

-- 7. Check for NULL values in critical columns
SELECT 
    SUM(CASE WHEN Order_ID IS NULL THEN 1 ELSE 0 END) AS OrderID_nulls,
    SUM(CASE WHEN Order_Date IS NULL THEN 1 ELSE 0 END) AS OrderDate_nulls,
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS CustomerID_nulls,
    SUM(CASE WHEN Product_ID IS NULL THEN 1 ELSE 0 END) AS ProductID_nulls,
    SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS Sales_nulls,
    SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END) AS Profit_nulls,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS Quantity_nulls
FROM [US Superstore data];

-- 8. Check for duplicate rows (complete row duplicates)
SELECT Order_ID, Product_ID, COUNT(*) AS duplicate_count
FROM [US Superstore data]
GROUP BY Order_ID, Product_ID
HAVING COUNT(*) > 1;

 Remove Duplicates
WITH CTE_Duplicates AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY Order_ID, Product_ID ORDER BY Order_Date) AS rn
  FROM [US Superstore data]
)
DELETE FROM CTE_Duplicates
WHERE rn > 1;

-- 9. Check for invalid data ranges
-- Negative sales or profit
SELECT COUNT(*) AS negative_sales FROM [US Superstore data] WHERE Sales < 0;  
SELECT COUNT(*) AS negative_profit FROM [US Superstore data] WHERE Profit < 0; 

-- Invalid dates (future dates)
SELECT COUNT(*) AS future_orders FROM [US Superstore data] WHERE Order_Date > GETDATE(); 

-- 10. Validate categorical values
-- Check Region values
SELECT DISTINCT Region FROM [US Superstore data]; 

-- Check Category values
SELECT DISTINCT Category FROM [US Superstore data]; 

-- 11. Check for inconsistent data
-- Orders where Ship_Date is before Order_Date
SELECT COUNT(*) AS invalid_ship_dates 
FROM [US Superstore data] 
WHERE Ship_Date < Order_Date;

-- 12. Data type validation
-- Check if numeric fields contain non-numeric data (for columns stored as text)
SELECT Sales FROM [US Superstore data] WHERE ISNUMERIC(Sales) = 0;
SELECT Profit FROM [US Superstore data] WHERE ISNUMERIC(Profit) = 0;
 
-- 13. 12% Profit Growth in West Region:
SELECT Region, 
       ROUND(SUM(Profit) * 100.0 / NULLIF(SUM(Sales), 0), 2) AS Profit_Margin
FROM [US Superstore data]
GROUP BY Region
ORDER BY Profit_Margin DESC;

-- 14. Profit margin opportunity in West by Sub-Category
SELECT Sub_Category, 
       ROUND(SUM(Profit) * 100.0 / NULLIF(SUM(Sales), 0), 2) AS Profit_Margin
FROM [US Superstore data]
WHERE Region = 'West'
GROUP BY Sub_Category
ORDER BY Profit_Margin ASC;  -- Focus on low-margin items