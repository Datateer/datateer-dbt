{%- macro try_cast(datatype, str) -%}
  {{ adapter_macro('datateer.try_cast', datatype, str) }}
{%- endmacro -%}


{% macro default__try_cast(datatype, str) %}
   {{ exceptions.raise_compiler_error("try_cast isn't supported on this database")}}
{% endmacro %}

{%- macro redshift__try_cast(datatype, str) -%}
{%- if datatype == 'timestamp' -%}
  case when left(trim({{str}}), 19) similar to '[0-9]{4}-[0-9]{2}-[0-9]{2}( |T)[0-9]{2}:[0-9]{2}:[0-9]{2}' then left(trim({{str}}), 19) else null end::{{datatype}}
{%- elif datatype == 'date' -%}
  case 
    when left(trim({{str}}), 5) similar to '[0-9]{4}-' then trim({{str}}) 
    when left(trim({{str}}), 7) similar to '[0-9]{2}-%%%-' then trim({{str}})
    else null 
  end::{{datatype}}
{%- elif datatype == 'int' or datatype == 'bigint' -%}
  case when trim({{str}}) ~ '^[0-9]+$' then trim({{str}}) else null end::{{datatype}}
{%- elif datatype.startswith('decimal(') or datatype.startswith('numeric(') -%}
  case when replace(replace(trim({{str}}), ',', ''), '$', '') similar to '[0-9]+(.[0-9]{2})*' then replace(replace(trim({{str}}), ',', ''), '$', '') else null end::{{datatype}}
{%- else -%}
  {{ exceptions.raise_compiler_error("The macro try_cast did not recognize the datatype: " + datatype)}}
{%- endif -%}
{%- endmacro -%}
