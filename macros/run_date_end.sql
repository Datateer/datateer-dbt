{#-
  Gets the run_date_end, if it has been provided as a variable. Otherwise gets current_date + 1 day
  Example:
    select * from table where date_column < {{ datateer.run_date_end() }}
-#}
{%- macro run_date_end() -%}
{%- if var("run_date_start", none) is not none -%}'{{ var("run_date_end")}}'::date{%- else -%}current_date{%- endif -%}
{%- endmacro -%}