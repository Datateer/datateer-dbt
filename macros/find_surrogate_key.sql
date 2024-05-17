{% macro find_surrogate_key(table_name, schema_name, database_name="RAW", sample_size=None) %}
{{ log('Starting to find surrogate key for table: ' ~ database_name ~ '.' ~ schema_name ~ '.' ~ table_name, info=True) }}

-- Handle sampling if specified
{% set sample_clause = "" %}
{% if sample_size %}
    {% if sample_size < 1 %}
        {% set sample_clause = "TABLESAMPLE BERNOULLI(" ~ (sample_size * 100) ~ ")" %}
    {% endif %}
{% endif %}

-- Check if the table has records
{% set records_check_query %}
    SELECT COUNT(*) AS total_count
    FROM {{ database_name }}.{{ schema_name }}.{{ table_name }}
{% endset %}

{% set records_result = run_query(records_check_query) %}
{% set total_records = records_result.columns[0].values()[0] %}

-- If no records, log and return message
{% if total_records == 0 %}
    {{ print('No records in raw table so cannot evaluate potential surrogate keys') }}
    {{ return('No records in raw table so cannot evaluate potential surrogate keys') }}
{% endif %}


{% set column_query = get_columns_query(database_name, table_name, schema_name) %}
{% set result = run_query(column_query) %}
{% set columns = result.columns[0].values() %}
{% set potential_keys = [] %}

-- Evaluate uniqueness for each column
{% for column in columns %}
    {{ log('Checking column: ' ~ column, info=True) }}
    {% set unique_count_query %}
        SELECT COUNT(DISTINCT "{{ column }}") AS unique_count,
               COUNT(*) AS total_count
        FROM {{ database_name }}.{{ schema_name }}.{{ table_name }}
        {{ sample_clause }}
    {% endset %}
    {{ log('Column check query: ' ~ unique_count_query, info=False) }}

    {% set results = run_query(unique_count_query) %}
    {% if results.columns[0].values()[0] == results.columns[1].values()[0] %}
        {% do potential_keys.append(column) %}
    {% endif %}
{% endfor %}

-- Check combinations of two and three columns if no single column is a definitive surrogate key
{% if potential_keys | length == 0 %}
    {% set all_combinations = generate_column_combinations(columns) %}

    -- Iterate through each combination to execute the uniqueness query
    {% for combined_columns in all_combinations %}
        {% set combo_query %}
            SELECT COUNT(DISTINCT CONCAT({{ combined_columns }})) AS unique_count,
                   COUNT(*) AS total_count
            FROM {{ database_name }}.{{ schema_name }}.{{ table_name }}
            WHERE _sdc_batched_at = (SELECT MAX(_sdc_batched_at) FROM {{ database_name }}.{{ schema_name }}.{{ table_name }})
            {{ sample_clause }}
        {% endset %}
        {{ log('Combination check query: ' ~ combo_query, info=True) }}
        {% set combo_results = run_query(combo_query) %}

        -- Check if the combination provides a unique set of values
        {% if combo_results.columns[0].values()[0] == combo_results.columns[1].values()[0] %}
            {% do potential_keys.append(combined_columns) %}
        {% endif %}
    {% endfor %}
{% endif %}

-- Return the list of potential keys or combinations
{% if potential_keys | length > 0 %}
   {{ log('Potential keys found: ' ~ potential_keys | join(' -and- '), info=True) }}

    -- Sort keys by the number of columns (count of commas + 1) and select the first one
    {% set potential_keys_sorted = potential_keys | sort(attribute='length') %}
    {% set shortest_key = potential_keys_sorted[0] | replace('"', '') | lower %}

    {{ log('Chosen surrogate key with the fewest columns: ' ~ shortest_key, info=True) }}
    {{ print(shortest_key) }}
{% else %}
    {{ log('No definitive surrogate key found.', info=True) }}
    {{ print('No definitive surrogate key found.') }}
{% endif %}

{% endmacro %}
