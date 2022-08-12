{%- macro try_cast(datatype, str) -%}
  {{ adapter.dispatch('try_cast', 'datateer')(datatype, str) }}
{%- endmacro -%}


{% macro default__try_cast(datatype, str) %}
   {{ exceptions.raise_compiler_error("try_cast isn't supported on this database")}}
{% endmacro %}

{%- macro bigquery__try_cast(datatype, str) -%}
{%- if datatype == 'timestamp' or datatype == 'datetime' -%}
  safe_cast('{{str}}' as datetime)
{%- elif datatype == 'date' or datatype == 'int' or datatype == 'bigint' or datatype == 'decimal' -%}
  safe_cast('{{str}}' as {{datatype}})
{%- else -%}
  {{ exceptions.raise_compiler_error("The macro try_cast did not recognize the datatype: " + datatype)}}
{%- endif -%}
{%- endmacro -%}


{%- macro redshift__try_cast(datatype, str) -%}
{%- if datatype == 'timestamp' -%}
  case 
    when left(trim({{str}}), 19) similar to '[0-9]{4}-[0-9]{2}-[0-9]{2}(( |T)[0-9]{2}:[0-9]{2}:[0-9]{2}){0,1}' then left(trim({{str}}), 19) 
    when left(trim({{str}}), 11) similar to '[0-9]{2}-[A-Za-z]{3}-[0-9]{4}' then left(trim({{str}}), 11)
	when left(trim({{str}}), 10) similar to '[0-9]{2}-[0-9]{2}-[0-9]{4}' then left(trim({{str}}), 10)
    else null 
  end::{{datatype}}
{%- elif datatype == 'date' -%}
  case 
    when left(trim({{str}}), 10) similar to '[0-9]{4}-[0-9]{2}-[0-9]{2}' then trim({{str}}) 
    when left(trim({{str}}), 11) similar to '[0-9]{2}-[A-Za-z]{3}-[0-9]{4}' then left(trim({{str}}), 11)
	when left(trim({{str}}), 10) similar to '[0-9]{2}-[0-9]{2}-[0-9]{4}' then left(trim({{str}}), 10)
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

{%- macro postgres__try_cast(datatype, str) -%}
{%- if datatype == 'timestamp' -%}
  case 
    when left(trim({{str}}), 19) similar to '[0-9]{4}-[0-9]{2}-[0-9]{2}(( |T)[0-9]{2}:[0-9]{2}:[0-9]{2}){0,1}' then left(trim({{str}}), 19) 
    when left(trim({{str}}), 11) similar to '[0-9]{2}-[A-Za-z]{3}-[0-9]{4}' then left(trim({{str}}), 11)
	when left(trim({{str}}), 10) similar to '[0-9]{2}-[0-9]{2}-[0-9]{4}' then left(trim({{str}}), 10)
    else null 
  end::{{datatype}}
{%- elif datatype == 'date' -%}
  case 
    when left(trim({{str}}), 10) similar to '[0-9]{4}-[0-9]{2}-[0-9]{2}' then trim({{str}}) 
    when left(trim({{str}}), 11) similar to '[0-9]{2}-[A-Za-z]{3}-[0-9]{4}' then left(trim({{str}}), 11)
	when left(trim({{str}}), 10) similar to '[0-9]{2}-[0-9]{2}-[0-9]{4}' then left(trim({{str}}), 10)
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

