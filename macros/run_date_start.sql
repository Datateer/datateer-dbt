{#-
  Gets the run_date_start variable, if it has been provided as a variable. Otherwise gets current_date
  Example:
    select * from table where date_column > {{ datateer.run_date_start() }}

-#}
{%- macro run_date_start() -%}
{%- if var("run_date_start", none) is not none -%}cast('{{ var("run_date_start")}}' as date){%- else -%}{{ dbt.dateadd(datepart="day", interval=-1, from_date_or_timestamp='current_date') }}{%- endif -%}
{%- endmacro -%}    