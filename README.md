# Sales Performance Analysis Dashboard

**🎯Project Objective**<br>
---
To analyse a transactional sales dataset to uncover business performance, customer behavior, product profitability, and geographic distribution, to enhance operational efficiency. To demonstrate **SQL proficiency** and **Power BI visualization skills** to report business insights.

---

**🛠️ Skills Demonstrated**<br>
-	SQL: Aggregations, CTEs, Subqueries, Window functions
-	DAX: Sum, Divide, Distinctcount, Countrows
-	Power BI: Cards, Bar/Line Charts, Maps, Tree Maps, Top N Filtering
---

**📊 Dataset**<br>
*Source:* Kaggle - Sales Transactions csv (line-level data)<br>

*Key-Fields:*<br>
Order_Number, Order_Line_Number,<br> 
Sales, Quantity_Ordered, Price_Each,<br>
Year_Id, Month_Id, Quarter_Id,<br>
Product_Line, Product_Code,<br>
Customer_Name, Country, Territory<br>

*Time Period:* 2003 - 2005 (2 years and 5 months of data)

---

**🔍 SQL Analysis** (22 Queries)<br>
 Analysed the dataset using SQL queries covering business KPIs, time series, product performance, customer segmentation, and geographic distribution.<br>

>*Full Query Library:* [SQL Analysis File](SQL/Sales_Analysis.sql)<br>

*Core Business KPIs*<br>

Total Revenue: $9,442,219<br>
Total Orders: 290<br>
Total Order Lines: 2664  <br>
Average Order Value: $32,559<br>
Average Lines per Order: 9<br>

*Time Series Analysis*<br>

-	Yearly revenue trend
-	Monthly revenue trend with 3-month moving average
-	Quarterly revenue trend

*Product Performance* - Top Product Lines by Revenue:
1. Classic Cars: 39% ($3727559.67)
2. Vintage Cars: 19% ($1773127.19)
3. Motorcycles: 12% ($1129573.83)

*Customer Analysis* - Top Customer by Expense and Country:
1. Euro Shopping Channel: $ 795328.22 - Spain
2. Mini Gifts Distributors Ltd: $ 647596.31 - USA
3. Australian Collectors, Co: $ 200995.41 - Australia

*Geographic Analysis* - Top Markets by Revenue:
1. USA (NA): $3416477.64
2. SPAIN (): $ 1098721.03
3. France (EMEA): $ 1067131.83
---

**📈 Power BI Dashboard**<br>
 Transformed SQL results into an interactive dashboard with the visuals telling a complete business story.<br>

>*Dashboard File:* [Power BI Dashboard File](/Power%20BI/Sales_Analysis.pbix) <br>

*DAX Measures Applied:*<br>
- Average_Lines_Per_Order = DIVIDE([Total_Order_Lines],[Total_Orders])
- Average_Order_Value = DIVIDE([Total_Revenue],[Total_Orders]) 
- Total_Order_Lines = COUNTROWS(Sales)
- Total_Orders = DISTINCTCOUNT(Sales[Order_Number]) 
- Total_Revenue = SUM(Sales[Sales]) 
- Total_Units = SUM(Sales[Quantity_Ordered]) 
---

**💡 Key Business Insights**<br>
-	The business is making about $32,559 per order on average.
-	Revenue Growth: Revenue peaks in Q4, with steady year-over-year growth.
-	Product Concentration: Top 3 product lines (Classic Cars, Vintage Cars, Motorcycles) drive 70%+ of revenue. 
-	Customer Dependency: Top 10 customers contribute 30% of revenue.
-	Geographic Focus: Top 3 countries (USA, Spain, France) generate 60% of revenue.
-	Revenue is highly concentrated in a few products, customers, and countries.
---

