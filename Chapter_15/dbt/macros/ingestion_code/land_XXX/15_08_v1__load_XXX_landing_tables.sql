/**
 * This macro runs all the inividual macros to load the landing tables for the XXX source system.
 */
{%  macro load_XXX_landing_tables() %}
{{ log('*** Load the landing tables for XXX system ***', true) }}

{{ log('**   Setting up the LANDING / EXTERNAL tables schema, FF and STAGE for XXX system **', true) }}
{% do run_query(setup_XXX_sql()) %}

{{ log('*   load_YYYYYY *', true) }}
{% do load_YYYYYY() %}


{{ log('*** DONE Loading the landing tables for XXX system ***', true) }}
{%- endmacro %}