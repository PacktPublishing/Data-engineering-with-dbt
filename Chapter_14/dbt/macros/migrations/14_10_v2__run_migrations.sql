/** USAGE:
 # -- Adding a migration macro:
 # {#% do run_migration('V003_drop_table', database, schema_prefix) %#}
 #
 # -- How to report there are no migrations to run
 # {#% do log("No migrations to run.", info=True) %#}
 #
 # !! Remove the # from the above lines to uncomment
 # !! Update the string with the macro name!!
 */

{% macro run_migrations(
        database = target.database,
        schema_prefix = target.schema
) -%}

{% do run_migration('V003_drop_table', database, schema_prefix) %}

{%- endmacro %}


/**
 * == Helper macro ==
 * It that takes the name of the macro to be run, db and schema and runs it with logs.
 * It uses the context to get the function object from its name
 */
{% macro run_migration(migration_name, database, schema_prefix) %}
{% if execute %}
    {% do log("Running " ~ migration_name ~ " migration with database = "
            ~ database ~ ", schema_prefix = " ~ schema_prefix, info=True) %}

    {% set migration_macro = context.get(migration_name, none) %}
    {% do run_query(migration_macro(database, schema_prefix)) if migration_macro
          else log("!! Macro " ~ migration_name ~ " not found. Skipping call.", info=True) %}
{% endif %}
{% endmacro %}