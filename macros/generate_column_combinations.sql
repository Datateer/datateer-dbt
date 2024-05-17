{% macro generate_column_combinations(columns) %}
    {% set combinations = [] %}

    -- Generate all pairs of columns
    {% for i in range(columns | length) %}
        {% for j in range(i + 1, columns | length) %}
            {% set pair = '"' ~ columns[i] ~ '", "' ~ columns[j] ~ '"' %}
            {% do combinations.append(pair) %}
        {% endfor %}
    {% endfor %}

    {{ log('combinations: ' ~ combinations, info=False) }}
    {{ return(combinations) }}
{% endmacro %}
