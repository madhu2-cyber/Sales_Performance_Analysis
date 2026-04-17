USE Sales;

-- 1. Count of total rows
SELECT COUNT(*) AS Total_Rows FROM Sales;

-- 2. Viewing first 15 rows
SELECT * FROM Sales LIMIT 15;

-- 3. Total revenue
SELECT 
ROUND(SUM(Sales),2) AS Total_Revenue
FROM Sales;


-- ORDERS
-- 4. Count distinct orders and total order lines
SELECT 
COUNT(DISTINCT Order_Number) AS Total_Orders,
COUNT(*) AS Total_Order_Lines
FROM Sales;

-- 5. Revenue from each order
SELECT 
DISTINCT Order_Number,
COUNT(DISTINCT Order_Line_Number) AS Line_Count,
SUM(Quantity_Ordered) AS Total_Units,
ROUND(SUM(Sales),2) AS Order_Revenue
FROM Sales
GROUP BY Order_Number;

-- 6. Average order value and average order lines
WITH Order_Summary AS 
(
    SELECT 
	DISTINCT Order_Number,
	COUNT(DISTINCT Order_Line_Number) AS Line_Count,
	SUM(Sales) AS Order_Revenue
    FROM Sales
    GROUP BY Order_Number
)
SELECT
    ROUND(AVG(Order_Revenue),2) AS Average_Order_Value,
    ROUND(AVG(Line_Count),0)    AS Average_Lines_Per_Order
FROM Order_Summary;

-- 7. High-value orders (above average order value)
WITH Order_Summary AS 
(
    SELECT 
	DISTINCT Order_Number,
	COUNT(DISTINCT Order_Line_Number) AS Line_Count,
	ROUND(SUM(Sales),2) AS Order_Revenue
    FROM Sales
    GROUP BY Order_Number
)
SELECT *
FROM Order_Summary
WHERE Order_Revenue > 33000 AND Line_Count > 9
ORDER BY Order_Revenue DESC;

-- 8. Top 10% highest-value orders
WITH Order_Summary AS 
(
    SELECT 
	Order_Number,
	SUM(Sales) AS Order_Revenue
    FROM Sales
    GROUP BY Order_Number
),
Order_Percentile AS
(
    SELECT
	Order_Number,
	ROUND(Order_Revenue,2) AS Revenue,
	NTILE(10) OVER (ORDER BY Order_Revenue DESC) AS Revenue_Decile
    FROM Order_Summary
)
SELECT 
Order_Number,
Revenue,
Revenue_Decile
FROM Order_Percentile
WHERE Revenue_Decile = 1
ORDER BY Revenue DESC;

-- PRODUCT
-- 9. Revenue by product line
SELECT 
Product_Line,
ROUND(SUM(Sales),2) AS Total_Revenue,
COUNT(*) AS Line_Items
FROM Sales
GROUP BY Product_Line
ORDER BY Total_Revenue DESC;

-- 10. Revenue share percent of each product line
SELECT
Product_Line,
ROUND(SUM(Sales),2) AS Total_Revenue,
ROUND(100.0 * SUM(Sales) / SUM(SUM(Sales)) OVER (),2) AS Revenue_Share_Percent
FROM Sales
GROUP BY Product_Line
ORDER BY Total_Revenue DESC;

-- 11. Top 10 products by revenue
SELECT 
Product_Code,
Product_Line,
ROUND(SUM(Sales),2) AS Total_Revenue,
SUM(Quantity_Ordered) AS Total_Units
FROM Sales
GROUP BY Product_Code, Product_Line
ORDER BY Total_Revenue DESC
LIMIT 10;

-- 12. Rank products by revenue
SELECT
Product_Code,
Product_Line,
ROUND(SUM(Sales),2) AS Total_Revenue,
RANK() OVER (ORDER BY SUM(Sales) DESC) AS Revenue_Rank
FROM Sales
GROUP BY Product_Code, Product_Line
ORDER BY Revenue_Rank;

-- CUSTOMER
-- 13. Top 10 customers by expense
SELECT 
Customer_Name,
Country,
ROUND(SUM(Sales),2) AS Total_Expense,
COUNT(DISTINCT Order_Number) AS Orders_Count
FROM Sales
GROUP BY Customer_Name, Country
ORDER BY Total_Expense DESC
LIMIT 10;

-- 14. Customers rank within each country
SELECT
Country,
Customer_Name,
ROUND(SUM(Sales),2) AS Total_Expense,
RANK() OVER (
			PARTITION BY Country 
			ORDER BY SUM(Sales) DESC
			) AS Rank_in_Country
FROM Sales
GROUP BY Country, Customer_Name
ORDER BY Country, Rank_in_Country;

-- 15. Customers whose average order value is above overall average
WITH Order_Summary AS (
    SELECT 
        Order_Number,
        Customer_Name,
        SUM(Sales) AS Order_Revenue
    FROM Sales
    GROUP BY Order_Number, Customer_Name
),
Customer_Avg AS (
    SELECT 
        Customer_Name,
        ROUND(AVG(Order_Revenue),2) AS Average_Order_Value
    FROM Order_Summary
    GROUP BY Customer_Name
)
SELECT 
    Customer_Name,
    Average_Order_Value
FROM Customer_Avg
WHERE Average_Order_Value > 
(
    SELECT AVG(Order_Revenue) 
    FROM Order_Summary
)
ORDER BY Average_Order_Value DESC;

-- COUNTRY
-- 16. Top countries by revenue
SELECT 
Country,
ROUND(SUM(Sales),2) AS Total_Revenue,
COUNT(DISTINCT Customer_Name) AS Unique_Customers
FROM Sales
GROUP BY Country
ORDER BY Total_Revenue DESC;

-- 17. Revenue by territory
SELECT 
Territory,
ROUND(SUM(Sales),2) AS Total_Revenue,
COUNT(DISTINCT Order_Number) AS Orders_Count
FROM Sales
GROUP BY Territory
ORDER BY Total_Revenue DESC;

-- 18. City performance in top revenue country
SELECT 
City,
ROUND(SUM(Sales),2) AS City_Revenue
FROM Sales
WHERE Country = 
(
    SELECT Country
    FROM Sales
    GROUP BY Country
    ORDER BY SUM(Sales) DESC
    LIMIT 1
)
GROUP BY City
ORDER BY City_Revenue DESC
LIMIT 10;

-- TIME
-- 19. Revenue each year
SELECT 
Year_Id AS Year,
ROUND(SUM(Sales),2) AS Revenue
FROM Sales
GROUP BY Year
ORDER BY Year;

-- 20. Monthly revenue in 2004
SELECT 
Month_Id AS Month,
ROUND(SUM(Sales),2) AS Revenue_2004
FROM Sales
WHERE Year_Id = 2004
GROUP BY Month
ORDER BY Month;

-- 21. Quarterly revenue year-over-year
SELECT 
Year_Id,
Quarter_Id,
ROUND(SUM(Sales),2) AS Quarterly_Revenue,
COUNT(DISTINCT Order_Number) AS Orders_Count
FROM Sales
GROUP BY Year_Id, Quarter_Id
ORDER BY Year_Id, Quarter_Id;

-- 22. Monthly revenue with 3-month moving average
WITH Monthly_Revenue AS 
(
    SELECT
	Year_Id,
	Month_Id,
	ROUND(SUM(Sales),2) AS Month_Revenue
    FROM Sales
    GROUP BY Year_Id, Month_Id
)
SELECT
Year_Id,
Month_Id,
Month_Revenue,
ROUND(AVG(Month_Revenue) OVER (ORDER BY Year_Id, Month_Id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS 3_Month_Moving_Average
FROM Monthly_Revenue
ORDER BY Year_Id, Month_Id;

