{% macro current_from_history_with_multiple_versions(
    history_rel, 
    key_column,
    sort_expr,
    selection_expr = '*',
    load_ts_column = 'LOAD_TS_UTC',
    history_filter_expr = 'true',
    qualify_function = '(rn = cnt) and rank'
) %}

{%- set multiple_versions_selection_expression %}
    {{selection_expr}}
    , row_number() OVER( PARTITION BY {{key_column}}, {{load_ts_column}} ORDER BY {{sort_expr}}) as rn
    , count(*) OVER( PARTITION BY {{key_column}}, {{load_ts_column}}) as cnt
{%- endset -%}

{{current_from_history(
    history_rel = history_rel, 
    key_column = key_column,
    selection_expr = multiple_versions_selection_expression,
    load_ts_column = load_ts_column,
    history_filter_expr = history_filter_expr,
    qualify_function = qualify_function
) }}

{% endmacro %}