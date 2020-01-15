{#-
  Gets the run_date_end, if it has been provided as a variable. Otherwise gets current_date + 1 day
  Example:
    select * from table where date_column < {{ run_date_end() }}
-#}
{%- macro run_date_end() -%}
coalesce(nullif('{{ var("run_date_end", null) }}', '')::date, current_date + interval '1 day')
{%- endmacro -%}