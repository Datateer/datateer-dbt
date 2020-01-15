{#-
  Gets the run_date_start variable, if it has been provided as a variable. Otherwise gets current_date
  Example:
    select * from table where date_column > {{ run_date_start() }}
-#}
{%- macro run_date_start() -%}
coalesce(nullif('{{ var("run_date_start", null) }}', '')::date, current_date)
{%- endmacro -%}    