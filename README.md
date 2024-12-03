# Finance and Market Analytics Project

Welcome to the Finance and Market Analytics project repository. This project leverages SQL to perform various analyses and generate insights related to finance and market data. Below, you'll find an overview of the project's contents and key aspects.

## Project Contents

**1. SQL Queries For Analysis:**
- Finance Analytics report : This file contains SQL queries that calculate monthly and annual sales for a specific customer named "Croma."
- Top Products, Customers and Markets report : This file includes SQL queries that perform various operations to calculate net sales, and then identify the top customers, top products, and top markets based on the results.
- Supply Chain Analytics report : The SQL queries in this file assess forecast accuracy for the years 2020 and 2021, and provide a comparison between the two years.

**2. Views:** We've created a view named net_sales to simplify the process of finding net sales. You can use this view instead of writing the same query repeatedly.

**3. Stored Procedures:**
- get_forecast_accuracy.sql : This stored procedure calculates forecast accuracy for a given period.
- get_top_n_customers_by_net_sales.sql : This stored procedure identifies the top customers based on sales.
- get_top_n_products_by_net_sales.sql : This stored procedure identifies the top products based on sales.
- get_top_n_markets_by_net_sales.sql : This stored procedure identifies the top markets based on sales.
- get_market_badge.sql : This stored procedure assigns a market badge value (e.g., "GOLD" or "SILVER") based on sales performance.

**4. Functions:**
- get_fiscal_year.sql : This function is designed to find the fiscal year for a given date.
- get_fiscal_quarter.sql : This function calculates the fiscal quarter for a given date.

