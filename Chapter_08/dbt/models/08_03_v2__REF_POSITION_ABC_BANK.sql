WITH

current_from_snapshot as (
   {{ current_from_snapshot(
        snsh_ref = ref('SNSH_ABC_BANK_POSITION'),
        output_load_ts = false
    ) }}
)

SELECT
    *
     , POSITION_VALUE - COST_BASE as UNREALIZED_PROFIT
     , ROUND(UNREALIZED_PROFIT / COST_BASE, 5)*100 as UNREALIZED_PROFIT_PCT
FROM current_from_snapshot