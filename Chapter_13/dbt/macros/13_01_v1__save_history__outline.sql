{% macro save_history(
    input_rel,
    key_column,
    diff_column,
) -%}    -- ... the other params are to improve performance

{{ config(materialized='incremental') }}

WITH

{%- if is_incremental() %}
current_from_history as (
-- get the current HDIFF for each HKEY
    ),

load_from_input as (
-- join the input with the HIST on the HDIFF column
-- and keep the rows where there is no match
    )

{%- else %}
load_from_input as (
-- load all from the input
)
{%- endif %}

SELECT * FROM load_from_input
-- ORDER BY option to optimize writes
{%- endmacro %}