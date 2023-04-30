{% macro save_history_with_deletion(
    input_rel, 
    key_column,
    diff_column,
    load_ts_column = 'LOAD_TS_UTC'
) -%}

{{ config(materialized='incremental') }}

WITH

{% if is_incremental() %}-- in an incremental run and the dest table already exists
current_from_history as (
    {{- current_from_history(
        history_rel = this,
        key_column = key_column,
        load_ts_column = load_ts_column,
    ) }}
),

load_from_input as (
    SELECT 
          i.* EXCLUDE ({{load_ts_column}})
        , i.{{load_ts_column}}
        , false as deleted
    FROM {{ input_rel }} as i
    LEFT OUTER JOIN current_from_history curr ON (not curr.deleted and i.{{diff_column}} = curr.{{diff_column}})
    WHERE curr.{{diff_column}} is null 
),
deleted_from_hist as (
    SELECT 
        curr.* EXCLUDE (deleted, {{load_ts_column}})
        , '{{ run_started_at }}' as {{load_ts_column}}
        , true as deleted
    FROM current_from_history curr 
    LEFT OUTER JOIN {{ input_rel }} as i ON (i.{{key_column}} = curr.{{key_column}})
    WHERE not curr.deleted and i.{{key_column}} is null 
),

changes_to_store as (
    SELECT * FROM load_from_input
    UNION ALL
    SELECT * FROM deleted_from_hist 
)
{%- else %}-- not an incremental run (like a full-refresh) or the dest table does not yet exists
changes_to_store as (
    SELECT 
        i.* EXCLUDE ({{load_ts_column}})
        , {{load_ts_column}}
        , false as deleted
    FROM {{ input_rel }} as i
)
{%- endif %}

SELECT * FROM changes_to_store

{% endmacro %}
