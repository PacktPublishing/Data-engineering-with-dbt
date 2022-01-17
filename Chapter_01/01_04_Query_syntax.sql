/**
 * Chapter 1 - Section 4: Query syntax and operators
 */

-- NOTE: in many queries we have added "limit 100" at the end.
--       This is done to keep the result set short and the query as quick as possible
--       You can comment that out or raise the number, the query will still quick, but the result set will be long.

-- ** WITH clause **
-- 1. Check if we still have high priority orders pending
WITH
    high_prio_orders as (
        SELECT *
        FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."ORDERS"
        WHERE O_ORDERPRIORITY IN ('1-URGENT', '2-HIGH')
    )
SELECT count(*)
FROM high_prio_orders
WHERE O_ORDERDATE < '1998-01-01'
  and O_ORDERSTATUS = 'O';

-- 2. Calculate some metrics for the customers in the auto industry
WITH
auto_customer_key as (
  SELECT C_CUSTKEY 
  FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."CUSTOMER"
  WHERE C_MKTSEGMENT = 'AUTOMOBILE'
),
orders_by_auto_customer as (
  SELECT O_ORDERKEY
  FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS
  WHERE O_CUSTKEY in (SELECT * FROM auto_customer_key)
),
metrics as (
  SELECT 'customers' as metric, count(*) as value 
  FROM auto_customer_key

  UNION ALL

  SELECT 'orders by these customers', count(*)
  FROM orders_by_auto_customer
)
SELECT * FROM metrics;

-- ** SELECT clause **
-- Sample SELECT with alias
SELECT
    O_ORDERKEY,
    ord.O_CUSTKEY,
    cust.C_NAME as CUSTOMER_NAME
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS as ord
JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER as cust
      ON cust.C_CUSTKEY = ord.O_CUSTKEY
limit 100;

-- Sample SELECT with column numbers
SELECT $1 as ORDER_KEY, $2 as CUST_KEY
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS
limit 100;

-- Sample select with expressions
SELECT
    P_PARTKEY
     , UPPER(P_NAME) as P_NAME
     , P_RETAILPRICE
     , P_RETAILPRICE * 0.9 as P_DISCOUNTED_PRICE
FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."PART"
limit 100;

-- ** FROM clause **
-- no FROM clause
SELECT 1 + 1 as sum, current_date as today;

-- FROM VALUES, aka inline table
SELECT * FROM (
VALUES   ('IT', 'ITA', 'Italy')
        ,('US', 'USA', 'United States of America')
        ,('SF', 'FIN', 'Finland (Suomi)')
        as inline_table (code_2, code_3, country_name)
);

-- SELECT from multiple tables
SELECT count(*)
FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."LINEITEM" as l
   ,"SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."ORDERS"   as o
   ,"SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."CUSTOMER" as c
   ,"SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."PART"     as p
WHERE o.O_ORDERKEY = l.L_ORDERKEY
  and c.C_CUSTKEY  = o.O_CUSTKEY
  and p.P_PARTKEY  = l.L_PARTKEY
;

-- ** WHERE clause
-- Example of a Predicate
SELECT O_ORDERKEY, O_CUSTKEY, O_TOTALPRICE
FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."ORDERS"
WHERE O_TOTALPRICE > 500000
limit 100;

-- WHERE false example
SELECT O_ORDERKEY,O_CUSTKEY, 1 as an_int, null::number as a_num
FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."ORDERS"
WHERE false;

-- ** GROUP BY clause
-- group by column name
SELECT O_CUSTKEY, sum(O_TOTALPRICE)
FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."ORDERS"
GROUP BY O_CUSTKEY;

-- group by column number
SELECT O_CUSTKEY, sum(O_TOTALPRICE)
FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."ORDERS"
GROUP BY 1;

-- group by SQL expression
SELECT YEAR(O_ORDERDATE), sum(O_TOTALPRICE)
FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."ORDERS"
GROUP BY YEAR(O_ORDERDATE)
ORDER BY YEAR(O_ORDERDATE);

-- group by more than one expression
SELECT YEAR(O_ORDERDATE),MONTH(O_ORDERDATE),sum(O_TOTALPRICE)
FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."ORDERS"
GROUP BY YEAR(O_ORDERDATE), MONTH(O_ORDERDATE)
ORDER BY YEAR(O_ORDERDATE), MONTH(O_ORDERDATE);

-- ** HAVING clause
-- filtering on the count of rows by group
SELECT YEAR(O_ORDERDATE), MONTH(O_ORDERDATE), sum(O_TOTALPRICE)
FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."ORDERS"
GROUP BY YEAR(O_ORDERDATE), MONTH(O_ORDERDATE)
HAVING count(*) < 10000
ORDER BY YEAR(O_ORDERDATE), MONTH(O_ORDERDATE);

-- ** QUALIFY clause
-- Keep only the most recent row per order and line
SELECT *
FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."LINEITEM"
QUALIFY row_number() over(
            partition by L_ORDERKEY, L_LINENUMBER
            order by L_COMMITDATE desc ) = 1
limit 100;

-- Select the GOOD months, with sales above the yearly average
WITH
monthly_totals as (
    SELECT
        YEAR(O_ORDERDATE) as year,
        MONTH(O_ORDERDATE) as month,
        sum(O_TOTALPRICE) as month_tot
    FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."ORDERS"
    GROUP BY YEAR(O_ORDERDATE), MONTH(O_ORDERDATE)
)
SELECT year, month, month_tot
     ,avg(month_tot) over(partition by YEAR) as year_avg
FROM monthly_totals
QUALIFY month_tot > year_avg
ORDER BY YEAR, MONTH;

-- ** SQL Operators
--  Arithmetic operators
SELECT 1 + '2' as three, (3+2) * 4 as twenty
WHERE twenty % 2 = 0;

-- Comparison operators
SELECT 2 < 1 as nope, '3' != 'three' as yep
WHERE 1 != 2;

-- Logical operators
SELECT *,
       (C_ACCTBAL > 7500) AND (C_NATIONKEY = 24) as IS_TOP_US_CUST
FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."CUSTOMER"
WHERE (C_NAME IS NOT null) AND IS_TOP_US_CUST
limit 100;

-- Set Operators
SELECT C_NAME, C_ADDRESS, C_PHONE
FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."CUSTOMER"
WHERE C_NATIONKEY IN (8, 24)

UNION

SELECT C_NAME, C_ADDRESS, C_PHONE
FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."CUSTOMER"
WHERE C_MKTSEGMENT = 'AUTOMOBILE'
;

-- Subquery operators
SELECT C_NAME, C_ADDRESS, C_PHONE
FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."CUSTOMER"
WHERE C_NATIONKEY = (
    SELECT N_NATIONKEY
    FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."NATION"
    WHERE N_NAME = 'JAPAN'
)
limit 100;

-- Same query with IN operator
SELECT C_NAME, C_ADDRESS, C_PHONE
FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."CUSTOMER"
WHERE C_NATIONKEY IN (
    SELECT N_NATIONKEY
    FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."NATION"
    WHERE N_NAME IN ('JAPAN', 'CANADA')
);


