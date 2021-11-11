{%- macro convert_timezone(source_timezone, target_timezone, ts) -%}
  {{ adapter.dispatch('convert_timezone','datateer')(source_timezone, target_timezone, ts) }}
{%- endmacro -%}


{% macro default__convert_timezone(source_timezone, target_timezone, ts) %}
 -- not implemented
{% endmacro %}

{%- macro redshift__convert_timezone(source_timezone, target_timezone, ts) -%}
    convert_timezone({{source_timezone}}, '{{target_timezone}}', {{ts}})
{%- endmacro -%}


{%- macro postgres__convert_timezone(source_timezone, target_timezone, ts) -%}
    {{ts}} at time zone {{source_timezone}} at time zone '{{target_timezone}}'
{%- endmacro -%}