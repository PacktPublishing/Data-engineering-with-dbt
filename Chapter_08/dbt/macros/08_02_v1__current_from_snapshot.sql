{% macro current_from_snapshot(snsh_ref) %}
    SELECT 
        * EXCLUDE (DBT_SCD_ID, DBT_VALID_FROM, DBT_VALID_TO)
        RENAME (DBT_UPDATED_AT as SNSH_LOAD_TS_UTC)
    FROM {{ snsh_ref }}
    WHERE DBT_VALID_TO is null
{% endmacro %}
