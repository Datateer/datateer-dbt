/**
 * Macro: get_dbt_updated_at
 * Description: This macro generates a SQL snippet to create a 'dbt_updated_at' column
 * with the current timestamp, properly cast to the appropriate datetime or timestamp data type,
 * depending on the target data warehouse (Snowflake, BigQuery, or Redshift).
 * Usage: Include {{ get_dbt_updated_at() }} in your select statements to automatically
 * append the 'dbt_updated_at' column with the correct timestamp and data type.
 */

{% macro datateer_fields() %}

    {% if target.type == 'snowflake' %}
        -- Snowflake uses the TIMESTAMP_NTZ data type for timestamps without time zone.
        CAST(sysdate() AS TIMESTAMP_NTZ) AS dbt_updated_at
    {% elif target.type == 'bigquery' %}
        -- BigQuery's CURRENT_TIMESTAMP() returns a TIMESTAMP data type.
        CAST(current_timestamp() AS TIMESTAMP) AS dbt_updated_at
    {% elif target.type == 'redshift' %}
        -- Redshift's SYSDATE is equivalent to GETDATE() in SQL Server, returns a TIMESTAMP without time zone.
        CAST(SYSDATE AS TIMESTAMP) AS dbt_updated_at
    {% else %}
        -- Default case for other warehouses, adjust according to your needs.
        'Unknown' AS dbt_updated_at
    {% endif %}

{% endmacro %}
