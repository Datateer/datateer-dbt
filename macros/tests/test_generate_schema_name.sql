{% macro test_generate_schema_name(custom_schema_name, node) -%}

  {{ print('target profile name: ' ~ target.name) }}
  {{ print('custom_schema_name: ' ~ custom_schema_name) }}
  {{ print('target.schema: ' ~ target.schema if target.type == 'snowflake' else target.dataset) }}
  {{ print('generated schema name: ' ~ datateer.generate_schema_name(custom_schema_name, node))}}

{%- endmacro %}