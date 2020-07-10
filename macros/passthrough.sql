{#-
  Specifically designed to overcome a shortcoming in dbt-external-tables. See https://github.com/fishtown-analytics/dbt-external-tables/issues/33
  This macro will just return the value that is passed into it
-#}
{%- macro passthrough(name, value) -%}
  {{ return(value) }}
{%- endmacro -%}