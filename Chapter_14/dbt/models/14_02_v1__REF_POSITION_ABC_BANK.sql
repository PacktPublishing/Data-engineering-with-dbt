WITH

current_from_history as (
    {{ current_from_history(
        history_rel = ref('HIST_ABC_BANK_POSITION'), 
        key_column = 'POSITION_HKEY',
    ) }}
)

SELECT 
    *
    , POSITION_VALUE - COST_BASE as UNREALIZED_PROFIT
    , ROUND(UNREALIZED_PROFIT / COST_BASE, 5)*100 as UNREALIZED_PROFIT_PCT
FROM current_from_history
