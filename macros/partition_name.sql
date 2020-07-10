{#-
  Specifically designed to overcome a shortcoming in dbt-external-tables. See https://github.com/fishtown-analytics/dbt-external-tables/issues/33
  This macro will just return the value that is passed into it
-#}
{%- macro partition_name(name, value) -%}
  {% set path = value.replace(value, 'export_date=' + value) %}
  {{ return(path) }}
{%- endmacro -%}