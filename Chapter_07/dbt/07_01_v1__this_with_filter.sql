{% macro this_with_filter(arg1, arg2='XXXX') %}
SELECT * FROM {{this}}
{% if arg1 %}
WHERE {{arg1}} = {{arg2}}
    {% endif %}
{% endmacro %}