{#-
  Gets the run_date_start variable, if it has been provided as a variable. Otherwise gets current_date
  Example:
    select * from table where date_column > {{ datateer.run_date_start() }}

-#}
{%- macro run_date_start() -%}
{%- if var("run_date_start", none) is not none -%}'{{ var("run_date_start")}}'::date{%- else -%}current_date - interval '1 days'{%- endif -%}
{%- endmacro -%}    