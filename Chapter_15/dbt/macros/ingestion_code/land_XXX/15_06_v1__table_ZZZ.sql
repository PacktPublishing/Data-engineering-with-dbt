{%  macro load_ZZZ(
        db_name = get_XXX_ingestion_db_name(),
        schema_name = get_XXX_ingestion_schema_name(),
        stage_name = get_XXX_ingestion_stage_name(),
        format_name = None,
        table_name = 'ZZZ',
        pattern = '.*ZZZ[.]parquet'
) %}

    {% set full_table_name = db_name ~ '.' ~ schema_name ~ '.' ~ table_name %}

    {{ log('Creating table ' ~ full_table_name ~ ' if not exists', true) }}
    {% do run_query(X_Z__create_table_sql(full_table_name)) %}
    {{ log('Created table '  ~ full_table_name ~ ' if not exists', true) }}

    {% set field_expressions %}
        $1 as src_data,
        $1:ZZZ_CODE::string as ZZZ_CODE,
        $1:ZZZ_NAME::string as ZZZ_NAME,
        $1:ZZZ_VALUE::double as ZZZ_VALUE
    {% endset %}

    {{ log('Ingesting data in table ' ~ full_table_name ~ '.', true) }}
    {% do run_query(ingest_semi_structured_into_landing_sql(
            full_table_name,
            field_expressions,
            file_pattern = pattern,
            full_stage_name = stage_name,
            full_format_name = format_name
        ) ) %}
    {{ log('Ingested data in table ' ~ full_table_name ~ '.', true) }}

    /* Add a cleanup step of the LT when ingesting (big) full exports
     * A simple strategy is to keep the last N ingestion timestamps.
     */

{%- endmacro %}

{% macro X_Z__create_table_sql(full_table_name) %}

    -- ** Create table if not exists
    CREATE TRANSIENT TABLE {{ full_table_name }} IF NOT EXISTS 
    (
        -- Add declaration for table columns
        --  column type [[NOT] NULL],
        SRC_DATA variant,
        ZZZ_CODE string NOT NULL,
        ZZZ_NAME string,
        ZZZ_VALUE double,

        -- metadata
        FROM_FILE string,
        FILE_ROW_NUMBER integer,
        INGESTION_TS_UTC TIMESTAMP_NTZ(9)
    )
    COMMENT = '...';

{%- endmacro %}