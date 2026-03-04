{#-
  Gets the run date start. Resolution order:
    1. run_date_start (explicit date string, e.g. '2025-03-01') if provided
    2. run_date_start_days_ago (integer, N days before today) if provided
    3. Default: current_date - 1 day
  Example:
    select * from table where date_column > {{ datateer.run_date_start() }}
  Usage:
    dbt run --vars '{run_date_start: "2025-02-01"}'
    dbt run --vars '{run_date_start_days_ago: 7}'
-#}
{%- macro run_date_start() -%}
{%- if var("run_date_start", none) is not none -%}
  cast('{{ var("run_date_start") }}' as date)
{%- elif var("run_date_start_days_ago", none) is not none -%}
  {{ dbt.dateadd(datepart="day", interval=-var("run_date_start_days_ago"), from_date_or_timestamp='current_date') }}
{%- else -%}
  {{ dbt.dateadd(datepart="day", interval=-1, from_date_or_timestamp='current_date') }}
{%- endif -%}
{%- endmacro -%}    