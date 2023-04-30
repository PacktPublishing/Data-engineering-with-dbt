{% macro save_history_with_multiple_versions(
    input_rel, 
    key_column,
    diff_column,
    sort_expr,
    history_rel = this,
    load_ts_column = 'LOAD_TS_UTC',
    input_filter_expr = 'true',
    history_filter_expr = 'true',
    high_watermark_column = none,
    high_watermark_test = '>='
) -%}

{{- config(materialized='incremental') }}
{%- if execute and not flags.FULL_REFRESH %}
    {% set incremental_w_external_input = (history_rel != this) %}
{% endif -%}

WITH 
{% if is_incremental() or incremental_w_external_input %}

{%- set selection_expression %}
    {{key_column}}, {{diff_column}}
    , row_number() OVER( PARTITION BY {{key_column}}, {{load_ts_column}} ORDER BY {{sort_expr}}) as rn
    , count(*) OVER( PARTITION BY {{key_column}}, {{load_ts_column}}) as cnt
{%- endset -%}

current_from_history as (
    {{current_from_history(
        history_rel = history_rel, 
        key_column = key_column,
        selection_expr = selection_expression,
        load_ts_column = load_ts_column,
        history_filter_expr = history_filter_expr,
        qualify_function = '(rn = cnt) and rank'
    ) }}
),

load_from_input as (
    SELECT 
        i.*
        , LAG(i.{{diff_column}}) OVER(PARTITION BY i.{{key_column}} ORDER BY {{sort_expr}}) as PREV_HDIFF
        , CASE 
            WHEN PREV_HDIFF is null THEN COALESCE(i.{{diff_column}} != h.{{diff_column}}, true)
            ELSE (i.{{diff_column}} != PREV_HDIFF) 
          END as TO_BE_STORED
    FROM {{input_rel}} as i
    LEFT OUTER JOIN current_from_history as h ON h.{{key_column}} = i.{{key_column}}
    WHERE {{input_filter_expr}}
    {%- if high_watermark_column %}        
        and {{high_watermark_column}} {{high_watermark_test}} (select max({{high_watermark_column}}) from {{ history_rel }}) 
    {%- endif %}
)

{%- else %}
load_from_input as (
    SELECT 
        i.*
        , LAG(i.{{diff_column}}) OVER(PARTITION BY i.{{key_column}} ORDER BY {{sort_expr}}) as PREV_HDIFF
        , CASE 
            WHEN PREV_HDIFF is null THEN true
            ELSE (i.{{diff_column}} != PREV_HDIFF) 
          END as TO_BE_STORED
    FROM {{input_rel}} as i
    WHERE {{input_filter_expr}}
)    
{%- endif %}

SELECT * EXCLUDE(PREV_HDIFF, TO_BE_STORED)
FROM load_from_input
WHERE TO_BE_STORED
ORDER BY {{key_column}}, {{sort_expr}}

{%- endmacro %}