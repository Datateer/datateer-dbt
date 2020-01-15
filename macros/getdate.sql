{%- macro getdate() -%}
  {{ adapter_macro('datateer.getdate') }}
{%- endmacro -%}


{% macro default__getdate() %}
 -- not implemented
{% endmacro %}

{%- macro redshift__getdate() -%}
    getdate()
{%- endmacro -%}


{%- macro postgres__getdate() -%}
    now() at time zone 'utc'
{%- endmacro -%}