/**
 * Chapter 1 - Section 6: Advanced: window function introduction
 */

-- Calculating daily or monthly measures with window functions
SELECT
    O_ORDERKEY,
    O_CUSTKEY,
    O_ORDERDATE,
    O_TOTALPRICE,
    avg(O_TOTALPRICE) over(partition by O_ORDERDATE) as daily_avg,
    sum(O_TOTALPRICE) over(partition by O_ORDERDATE) as daily_total,
    sum(O_TOTALPRICE) over(partition by
        DATE_TRUNC(MONTH, O_ORDERDATE)) as monthly_total,
    O_TOTALPRICE / daily_avg * 100 as avg_pct,
    O_TOTALPRICE / daily_total * 100 as day_pct,
    O_TOTALPRICE / monthly_total * 100 as month_pct
FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."ORDERS"
QUALIFY row_number() over(partition by O_ORDERDATE
                          order by O_TOTALPRICE DESC) <= 5
order by O_ORDERDATE, O_TOTALPRICE desc;



