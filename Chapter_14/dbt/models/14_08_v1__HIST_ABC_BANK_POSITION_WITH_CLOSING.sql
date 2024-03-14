{{ config(materialized='incremental') }}

WITH
stg_input as (
    SELECT 
        i.* EXCLUDE (REPORT_DATE, QUANTITY, COST_BASE, POSITION_VALUE, LOAD_TS_UTC)
        , REPORT_DATE
        , QUANTITY
        , COST_BASE
        , POSITION_VALUE
        , LOAD_TS_UTC
        , false as CLOSED
    FROM {{ ref('STG_ABC_BANK_POSITION') }} as i
)

{% if is_incremental() %}-- in an incremental run and the dest table already exists
, current_from_history as (
    {{ current_from_history(
        history_rel = this,
        key_column = 'POSITION_HKEY',
    ) }}
),

load_from_input as (
    SELECT 
        i.* 
    FROM stg_input as i
    LEFT OUTER JOIN current_from_history curr ON (not curr.closed and i.POSITION_HDIFF = curr.POSITION_HDIFF)
    WHERE curr.POSITION_HDIFF is null 
),
closed_from_hist as (
    SELECT 
        curr.* EXCLUDE (REPORT_DATE, QUANTITY, COST_BASE, POSITION_VALUE, LOAD_TS_UTC, CLOSED)
        , (SELECT MAX(REPORT_DATE) FROM stg_input) as REPORT_DATE
        , 0 as QUANTITY
        , 0 as COST_BASE
        , 0 as POSITION_VALUE
        , '{{ run_started_at }}' as LOAD_TS_UTC
        , true as CLOSED
    FROM current_from_history curr 
    LEFT OUTER JOIN stg_input as i ON (i.POSITION_HKEY = curr.POSITION_HKEY)
    WHERE not curr.closed and i.POSITION_HKEY is null 
),

changes_to_store as (
    SELECT * FROM load_from_input
    UNION ALL
    SELECT * FROM closed_from_hist 
)
{%- else %}-- not an incremental run (like a full-refresh) or the dest table does not yet exists
, changes_to_store as (
    SELECT * 
    FROM stg_input
)
{%- endif %}

SELECT * FROM changes_to_store
