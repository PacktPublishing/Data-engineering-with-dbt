{% macro current_from_history(
    history_rel,
    key_column,
    selection_expr = '*',
    load_ts_column = 'LOAD_TS_UTC',
    history_filter_expr = 'true',
    qualify_function = 'row_number'
) -%}

SELECT {{selection_expr}}
FROM {{history_rel}}
WHERE {{history_filter_expr}}
QUALIFY {{qualify_function}}() OVER( PARTITION BY {{key_column}} ORDER BY {{load_ts_column}} desc) = 1

{%- endmacro %}