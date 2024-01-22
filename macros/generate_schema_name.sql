{# 
    this macro overrides the out-of-the-box macro from dbt, to override the schema name generation behavior
    This is a best practice recommended by dbt to override this behavior (ref https://docs.getdbt.com/docs/build/custom-schemas)
    In short, dbt prefixes custom schema names with the database name, so that multiple environments in the same DW database do not conflict with each other
    The macro below overrides that so that in production, the database name is not prefixed onto the schema name
#}
{% macro generate_schema_name(custom_schema_name, node) -%}
    {{ log('Running datateer.generate_schema_macro') }}
    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}
        {{ default_schema }}
    {%- elif target.name == 'prod' -%}
        {# if production, do not do the default behavior of <db>_<schema>, just do <schema> #}
        {{ log('Environment is prod--overriding default schema name creation behavior. Schema name is: ' ~ custom_schema_name | trim) }}
        {{ custom_schema_name | trim }}
    {%- else -%}
        {# in non-prod environments, do the default behavior of <db>_<schema> so we avoid people writing to the prod schema #}
        {{ log('Environment is ' ~ target.name ~ 'so , using default schema name creation behavior. Schema name is: ' ~ default_schema ~ '_' ~ custom_schema_name | trim )}}
        {{ default_schema }}_{{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}