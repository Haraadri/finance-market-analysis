#Creating fact_act_est table

CREATE TABLE fact_act_est AS
    (
        SELECT 
            s.date AS date,
            EXTRACT(YEAR FROM s.date) AS fiscal_year,
            s.product_code AS product_code,
            s.customer_code AS customer_code,
            s.sold_quantity AS sold_quantity,
            f.forecast_quantity AS forecast_quantity
        FROM 
            fact_sales_monthly s
        LEFT JOIN fact_forecast_monthly f 
            ON s.date = f.date AND s.customer_code = f.customer_code AND s.product_code = f.product_code
    )
UNION
    (
        SELECT 
            f.date AS date,
            EXTRACT(YEAR FROM f.date) AS fiscal_year,
            f.product_code AS product_code,
            f.customer_code AS customer_code,
            s.sold_quantity AS sold_quantity,
            f.forecast_quantity AS forecast_quantity
        FROM 
            fact_forecast_monthly f
        LEFT JOIN fact_sales_monthly s 
            ON f.date = s.date AND f.customer_code = s.customer_code AND f.product_code = s.product_code
    );

#Updating fact_act_est table to 0 values from null

UPDATE fact_act_est
SET sold_quantity = 0
WHERE sold_quantity IS NULL;

UPDATE fact_act_est
SET forecast_quantity = 0
WHERE forecast_quantity IS NULL;

    
    
# Creating Forecast error table

WITH forecast_error_table AS (
    SELECT 
        fa.customer_code AS customer_code,
        c.customer AS customer_name,
        c.market AS market,
        SUM(fa.sold_quantity) AS total_sold_qty,
        SUM(fa.forecast_quantity) AS total_forecast_qty,
        SUM(fa.forecast_quantity - fa.sold_quantity) AS net_error,
        ROUND(SUM(fa.forecast_quantity - fa.sold_quantity) * 100 / SUM(fa.forecast_quantity), 2) AS net_error_pct,
        SUM(ABS(fa.forecast_quantity - fa.sold_quantity)) AS abs_error,
        ROUND(SUM(ABS(fa.forecast_quantity - fa.sold_quantity)) * 100 / SUM(fa.forecast_quantity), 2) AS abs_error_pct
    FROM fact_act_est fa
    JOIN dim_customer c ON fa.customer_code = c.customer_code
    WHERE fa.fiscal_year = 2021
    GROUP BY fa.customer_code
)
SELECT
    *, 
    IF(abs_error_pct > 100, 0, 100.0 - abs_error_pct) AS forecast_accuracy
FROM forecast_error_table
ORDER BY forecast_accuracy DESC;

    
    
    
 # Exercise 2021 vs 2020 forecast accuracy 
 
 CREATE TEMPORARY TABLE forecast_accuracy_2020 AS
WITH forecast_error_table AS (
    SELECT 
        fa.customer_code AS customer_code,
        c.customer AS customer_name,
        c.market AS market,
        SUM(fa.sold_quantity) AS total_sold_qty,
        SUM(fa.forecast_quantity) AS total_forecast_qty,
        SUM(fa.forecast_quantity - fa.sold_quantity) AS net_error,
        ROUND(SUM(fa.forecast_quantity - fa.sold_quantity) * 100 / SUM(fa.forecast_quantity), 2) AS net_error_pct,
        SUM(ABS(fa.forecast_quantity - fa.sold_quantity)) AS abs_error,
        ROUND(SUM(ABS(fa.forecast_quantity - fa.sold_quantity)) * 100 / SUM(fa.forecast_quantity), 2) AS abs_error_pct
    FROM fact_act_est fa
    JOIN dim_customer c ON fa.customer_code = c.customer_code
    WHERE fa.fiscal_year = 2020
    GROUP BY fa.customer_code
)
SELECT
    *, 
    IF(abs_error_pct > 100, 0, 100.0 - abs_error_pct) AS forecast_accuracy
FROM forecast_error_table
ORDER BY forecast_accuracy DESC;

    
    
    
    
CREATE TEMPORARY TABLE forecast_accuracy_2021 AS
WITH forecast_error_table AS (
    SELECT 
        fa.customer_code AS customer_code,
        c.customer AS customer_name,
        c.market AS market,
        SUM(fa.sold_quantity) AS total_sold_qty,
        SUM(fa.forecast_quantity) AS total_forecast_qty,
        SUM(fa.forecast_quantity - fa.sold_quantity) AS net_error,
        ROUND(SUM(fa.forecast_quantity - fa.sold_quantity) * 100 / SUM(fa.forecast_quantity), 2) AS net_error_pct,
        SUM(ABS(fa.forecast_quantity - fa.sold_quantity)) AS abs_error,
        ROUND(SUM(ABS(fa.forecast_quantity - fa.sold_quantity)) * 100 / SUM(fa.forecast_quantity), 2) AS abs_error_pct
    FROM fact_act_est fa
    JOIN dim_customer c ON fa.customer_code = c.customer_code
    WHERE fa.fiscal_year = 2021
    GROUP BY fa.customer_code
)
SELECT
    *, 
    IF(abs_error_pct > 100, 0, 100.0 - abs_error_pct) AS forecast_accuracy
FROM forecast_error_table
ORDER BY forecast_accuracy DESC;
    
    
    
    
SSELECT 
    f20.customer_code,
    f20.customer_name,
    f20.market,
    f20.forecast_accuracy AS forecast_accuracy_2020,
    f21.forecast_accuracy AS forecast_accuracy_2021
FROM forecast_accuracy_2020 f20
JOIN forecast_accuracy_2021 f21 ON f20.customer_code = f21.customer_code 
WHERE f21.forecast_accuracy < f20.forecast_accuracy
ORDER BY f20.forecast_accuracy DESC;



 
 
 
 
 
 
 
 
    
    
   
    
    
    
 
    
    
    
    