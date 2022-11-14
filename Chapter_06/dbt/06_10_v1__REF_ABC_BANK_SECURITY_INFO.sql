WITH
    current_from_snapshot as (
        SELECT * EXCLUDE (DBT_SCD_ID, DBT_UPDATED_AT, DBT_VALID_FROM, DBT_VALID_TO)
        FROM {{ ref('SNSH_ABC_BANK_SECURITY_INFO') }}
WHERE DBT_VALID_TO is null
    )
SELECT *
FROM current_from_snapshot