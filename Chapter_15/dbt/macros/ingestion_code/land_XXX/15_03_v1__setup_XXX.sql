{%  macro run_setup_XXX() %}
    {{ log('**   Setting up the LANDING / EXTERNAL tables schema, FF and STAGE for XXX system **', true) }}
    {% do run_query(setup_XXX_sql()) %}
{%- endmacro %}

{%  macro setup_XXX_sql() %}
  {{ create_XXX_schema_sql() }}
  {{ create_XXX__ff_sql() }}
  {{ create_XXX__stage_sql() }}
{%- endmacro %}

/* DEFINE Names  */ 
{%  macro get_XXX_db_name() %}
  {% do return( target.database ) %}
{%- endmacro %}

{%  macro get_XXX_schema_name() %}
  {% do return( 'LAND_XXX' ) %}
{%- endmacro %}

{%  macro get_XXX_ff_name() %}  -- return fully qualified name
  {% do return( get_XXX_db_name() ~ '.' ~ get_XXX_schema_name() ~ '.XXX_CSV__FF' ) %}
{%- endmacro %}

{%  macro get_XXX_stage_name() %}    -- return fully qualified name
  {% do return( get_XXX_db_name() ~ '.' ~ get_XXX_schema_name() ~ '.XXX_CSV_STAGE' ) %}
{%- endmacro %}



{%  macro create_XXX_schema_sql() %}
CREATE SCHEMA IF NOT EXISTS {{ get_XXX_db_name() }}.{{ get_XXX_schema_name() }}
        COMMENT = 'The Landing Schema for XXX data.';
{%- endmacro %}



{%  macro create_XXX__ff_sql() %}
 
CREATE FILE FORMAT IF NOT EXISTS {{ get_XXX_ff_name() }}
    TYPE = 'csv' 
    field_delimiter = ','
    SKIP_HEADER = 1
    -- ENCODING = 'ISO-8859-1'  -- For nordic languages
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    ;

{# --If you make only one for all environments you need to authorize all roles
{% for env in var('environments') %}
GRANT USAGE ON FILE FORMAT {{ get_XXX_ff_name() }} TO ROLE {{ var('prj_name') }}_{{env}}_RW;
{%- endfor %}
#}

{%- endmacro %}


{%  macro create_XXX__stage_sql() %}

CREATE STAGE IF NOT EXISTS {{ get_XXX_stage_name() }}
  storage_integration = STORAGE_INTEGRATION_NAME
  url = 'azure://stg_account.blob.core.windows.net/XYZ-container/XXX/'
  file_format = {{ get_XXX_ff_name() }};

{# --If you make only one for all environments you need to authorize all roles
{% for env in var('environments') %}
GRANT USAGE ON STAGE {{ get_XXX_stage_name() }} TO ROLE {{ var('prj_name') }}_{{env}}_RW;
{%- endfor %}
#}

{%- endmacro %}