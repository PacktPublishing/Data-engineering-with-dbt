{% macro V003_drop_table(
        database = target.database,
        schema_prefix = target.schema
) -%}

DROP TABLE IF EXISTS  {{database}}.{{schema_prefix}}_REFINED.REF_ABC_BANK_SECURITY_INFO ;

{%- endmacro %}