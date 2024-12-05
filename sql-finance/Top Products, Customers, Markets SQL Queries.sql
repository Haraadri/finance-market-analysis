
#1. Joining Products Table with Pre-Invoice Deduction Table

SELECT 
    s.date, 
    s.product_code, 
    p.product, 
    p.variant, 
    s.sold_quantity, 
    g.gross_price,
    ROUND(s.sold_quantity * g.gross_price, 2) AS gross_price_total,
    ped.pre_invoice_discount_pct
FROM fact_sales_monthly s
JOIN dim_date dt
    ON dt.calendar_date = s.date
JOIN dim_product p
    ON s.product_code = p.product_code
JOIN fact_gross_price g
    ON g.fiscal_year = dt.fiscal_year
    AND g.product_code = s.product_code
JOIN fact_pre_invoice_deductions ped
    ON ped.fiscal_year = dt.fiscal_year
    AND ped.customer_code = s.customer_code
WHERE dt.fiscal_year = 2021     
LIMIT 1000000;


#2. After Adding `fiscal_year` Column to fact_sales_monthly Table


SELECT 
    s.date, 
    s.product_code, 
    p.product, 
    p.variant, 
    s.sold_quantity, 
    g.gross_price,
    ROUND(s.sold_quantity * g.gross_price, 2) AS gross_price_total,
    ped.pre_invoice_discount_pct
FROM fact_sales_monthly s
JOIN dim_product p
    ON s.product_code = p.product_code
JOIN fact_gross_price g
    ON g.fiscal_year = s.fiscal_year
    AND g.product_code = s.product_code
JOIN fact_pre_invoice_deductions ped
    ON ped.fiscal_year = s.fiscal_year
    AND ped.customer_code = s.customer_code
WHERE s.fiscal_year = 2021     
LIMIT 1000000;


#3. Creating Query with `sales_preinvoice_discount` View for Joining `fact_post_invoice_deductions`


SELECT 
    *, 
    (gross_price_total - gross_price_total * pre_invoice_discount_pct) AS Net_Invoice_Sales,
    (pod.discounts_pct + pod.other_deductions_pct) AS post_invoice_discount_pct
FROM sales_preinvoice_discount sd
JOIN fact_post_invoice_deductions pod
    ON sd.date = pod.date
    AND sd.customer_code = pod.customer_code
    AND sd.product_code = pod.product_code;


#4. Finding Net Sales with `sales_postinvoice_discount` View


SELECT 
    *, 
    (1 - post_invoice_discount_pct) * Net_Invoice_Sales AS Net_Sales
FROM sales_postinvoice_discount;


#5. Finding Top Markets by Net Sales in Given Year


SELECT 
    market,
    ROUND(SUM(Net_Sales / 1000000), 2) AS Net_Sales_million
FROM net_sales
WHERE fiscal_year = 2021
GROUP BY market
ORDER BY Net_Sales_million DESC
LIMIT 5;


#6. Finding Top Customers by Net Sales


SELECT 
    customer,
    ROUND(SUM(Net_Sales / 1000000), 2) AS Net_Sales_million
FROM net_sales
WHERE fiscal_year = 2021 AND market = "India"
GROUP BY customer
ORDER BY Net_Sales_million DESC
LIMIT 5;


#7. Finding Top Products by Net Sales


SELECT 
    product,
    ROUND(SUM(Net_Sales / 1000000), 2) AS Net_Sales_million
FROM net_sales
WHERE fiscal_year = 2021
GROUP BY product
ORDER BY Net_Sales_million DESC
LIMIT 5;


#8. Preparing Graph for Customer Net Sales with `OVER` Clause


WITH cte AS (
    SELECT 
        customer,
        ROUND(SUM(Net_Sales / 1000000), 2) AS Net_Sales_million
    FROM net_sales
    WHERE fiscal_year = 2021
    GROUP BY customer
)
SELECT 
    *,
    (Net_Sales_million * 100) / SUM(Net_Sales_million) OVER() AS netsales_pct
FROM cte
ORDER BY Net_Sales_million DESC;


#9. Creating Pie Chart for Region-wise Market Share of Countries


WITH cte AS (
    SELECT 
        c.customer, 
        c.region,
        ROUND(SUM(Net_Sales / 1000000), 2) AS Net_Sales_million
    FROM net_sales ns
    JOIN dim_customer c 
        ON ns.customer_code = c.customer_code
    WHERE fiscal_year = 2021
    GROUP BY c.customer, c.region
)
SELECT 
    *,
    (Net_Sales_million * 100) / SUM(Net_Sales_million) OVER(PARTITION BY region) AS region_share_pct
FROM cte
ORDER BY region, region_share_pct DESC;
