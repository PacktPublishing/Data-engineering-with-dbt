-- Adding a migration macro:
-- {#% do run_query(V001_drop_XXX(database, schema_prefix)) %#}
-- {#% do log("V001_drop_XXX run with database = " ~ database ~ ", schema_prefix = " ~ schema_prefix, info=True) %#}
-- !! Remove the # from the above lines !!

{% macro run_migrations(
        database = target.database,
        schema_prefix = target.schema
) -%}

{% do log("Running V003_drop_table migration with database = "
            ~ database ~ ", schema_prefix = " ~ schema_prefix, info=True) %}
{% do run_query(V003_drop_table(database, schema_prefix)) %}


{%- endmacro %}
-- How to report there are no migrations to run
-- {#% do log("No migrations to run.", info=True) %#}
