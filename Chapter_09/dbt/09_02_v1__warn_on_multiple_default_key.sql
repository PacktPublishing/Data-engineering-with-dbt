{% test warn_on_multiple_default_key ( model
                          , column_name
                          , default_key_value = '-1'
                          , record_source_field_name = 'RECORD_SOURCE'
                          , default_key_record_source = 'System.DefaultKey'
    ) -%}

{{ config(severity = 'warn') }}

WITH

validation_errors as (
    SELECT distinct {{column_name}}, {{record_source_field_name}}
    FROM {{ model }}
    WHERE {{column_name}} != '{{default_key_value}}'
      and {{record_source_field_name}} = '{{default_key_record_source}}'
)

SELECT * FROM validation_errors

{%- endtest %}