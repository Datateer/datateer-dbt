{#-
  Gets a BETWEEN range condition between run_date_start and run_date_end, or sensible defaults if those are not specified.
  Example:
    select * from table where date_column {{ between_run_dates }}
-#}
{%- macro between_run_dates() -%}
between coalesce(nullif('{{ var("run_date_start", null) }}', '')::date, current_date) and coalesce(nullif('{{ var("run_date_end", null) }}', '')::date, current_date + interval '1 day')
{%- endmacro -%}