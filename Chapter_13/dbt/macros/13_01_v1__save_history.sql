{% macro save_history(
    input_rel,
    key_column,
    diff_column,
    load_ts_column = 'LOAD_TS_UTC',
    input_filter_expr = 'true',
    history_filter_expr = 'true',
    high_watermark_column = none,
    high_watermark_test = '>=',
    order_by_expr = none
) -%}

{{ config(materialized='incremental') }}

WITH

{%- if is_incremental() %}
current_from_history as (
    {{current_from_history(
        history_rel = this,
        key_column = key_column,
        selection_expr = diff_column,
        load_ts_column = load_ts_column,
        history_filter_expr = history_filter_expr
    ) }}
),

load_from_input as (
    SELECT i.*
    FROM {{input_rel}} as i
    LEFT OUTER JOIN current_from_history as h ON h.{{diff_column}} = i.{{diff_column}}
    WHERE h.{{diff_column}} is null
        and {{input_filter_expr}}
    {%- if high_watermark_column %}
        and {{high_watermark_column}} {{high_watermark_test}} (select max({{high_watermark_column}}) from {{ this }})
    {%- endif %}
)

{%- else %}
load_from_input as (
    SELECT *
    FROM {{input_rel}}
    WHERE {{input_filter_expr}}
)
{%- endif %}

SELECT * FROM load_from_input
{%- if order_by_expr %}
ORDER BY {{order_by_expr}}
{%- endif %}

{%- endmacro %}