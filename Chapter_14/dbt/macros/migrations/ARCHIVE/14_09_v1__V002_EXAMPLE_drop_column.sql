{% macro V003_drop_MD_column_in_customer() -%}

{%- set model = ref('REF_GROUP_CUSTOMER') %}
{%- set col = 'MD_LOAD_TS_UTC' %}

{%- if coulmn_exists(model, col) %}
ALTER TABLE {{ model }}
DROP COLUMN {{ col }};
{%- else %}
SELECT 1;
{%- endif %}
{%- endmacro %}