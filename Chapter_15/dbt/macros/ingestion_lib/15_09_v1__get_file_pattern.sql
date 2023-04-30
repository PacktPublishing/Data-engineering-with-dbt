{%- macro get_file_pattern(
        table_name,
        num_days = 5,
        last_date = None, 
        file_path_prefix = 'root-folder/',
        file_path_suffix = '[.]gz'
    ) -%}

{%- if last_date %}
    {%- set base_date = modules.datetime.date.fromisoformat(last_date) %}
{%- else %}
    {%- set base_date = modules.datetime.date.today() %}
{% endif -%}

{%- set dates = [] -%}
{%- for d in range(num_days) -%}
  {%- set time_delta = modules.datetime.timedelta(days=d) %}    
  {%- set _ = dates.append( (base_date-time_delta).strftime('%Y/%m/%d') ) -%}
{% endfor -%}
    
{{file_path_prefix}}{{table_name}}/({{dates|join('|')}})/.*{{table_name}}.*{{file_path_suffix}}

{%- endmacro %}