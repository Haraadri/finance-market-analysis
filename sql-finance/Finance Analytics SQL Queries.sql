# Finding Gross Sales of CROMA for the Fiscal Year 2021

SELECT 
    s.date, 
    s.product_code, 
    p.product, 
    p.variant, 
    s.sold_quantity, 
    g.gross_price,
    ROUND(s.sold_quantity * g.gross_price, 2) AS gross_price_total
FROM fact_sales_monthly s
JOIN dim_product p ON s.product_code = p.product_code
JOIN fact_gross_price g ON g.product_code = s.product_code
WHERE 
    s.customer_code = 'C001' AND 
    EXTRACT(YEAR FROM s.date) = 2021
LIMIT 1000000;

    
    
 
 # Croma Monthly Sales Report For All Years
 
 SELECT 
    s.date, 
    SUM(ROUND(s.sold_quantity * g.gross_price, 2)) AS monthly_sales
FROM fact_sales_monthly s
JOIN fact_gross_price g ON g.product_code = s.product_code
WHERE 
    s.customer_code = 'C001'
GROUP BY s.date
ORDER BY s.date;

    
    
# Croma Fiscal Year wise Sales Report

SELECT 
    EXTRACT(YEAR FROM s.date) AS Fiscal_Year, 
    SUM(ROUND(s.sold_quantity * g.gross_price, 2)) AS Total_Gross_Sales
FROM fact_sales_monthly s
JOIN fact_gross_price g ON g.product_code = s.product_code
WHERE 
    s.customer_code = 'C001'
GROUP BY EXTRACT(YEAR FROM s.date)
ORDER BY Fiscal_Year;

    

# Market Badge based on Performance

SELECT 
    SUM(s.sold_quantity) AS Total_qty_sold
FROM fact_sales_monthly s
JOIN dim_customer c ON s.customer_code = c.customer_code
WHERE 
    EXTRACT(YEAR FROM s.date) = 2021 AND 
    c.market = 'India'
GROUP BY c.market;





