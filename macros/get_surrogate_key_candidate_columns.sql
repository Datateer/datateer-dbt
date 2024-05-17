{% macro get_columns_query(database_name, table_name, schema_name) %}

{% set column_query %}
    SELECT COLUMN_NAME, DATA_TYPE
    FROM {{ database_name }}.INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME ilike '{{ table_name }}'
    AND TABLE_SCHEMA ilike '{{ schema_name }}'
    AND TABLE_CATALOG ilike '{{ database_name }}'
    AND COLUMN_NAME not ilike '_sdc_%'
    ORDER BY CASE
                 WHEN DATA_TYPE IN ('UNIQUEIDENTIFIER', 'GUID') THEN 0
                 WHEN COLUMN_NAME LIKE '%ID%' OR COLUMN_NAME LIKE '%KEY%' THEN 1
                 ELSE 2
             END, COLUMN_NAME
{% endset %}

{{ log('Generated column query: ' ~ column_query, info=True) }}
{% do return(column_query) %}

{% endmacro %}
