{% macro datediff(first_date, second_date, datepart) %}
  {{ adapter_macro('datateer.datediff', first_date, second_date, datepart) }}
{% endmacro %}


{% macro default__datediff(datepart, first_date, second_date) %}

    datediff(
        '{{ datepart }}',
        {{ first_date }},
        {{ second_date }}
        )

{% endmacro %}


{% macro postgres__datediff(datepart, first_date, second_date) %}
    DATE_PART('{{datepart}}', cast({{second_date}} as timestamp) - cast({{first_date}} as timestamp))

{% endmacro %}