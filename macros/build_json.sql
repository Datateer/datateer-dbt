{#-
  Builds a flat json structure and returns it as a varchar
-#}
{%- macro build_json(fields, size=5000) -%}
        '{' || 
        {% for field in fields %}
            {% if ':' in field %}
                {% set mapped_name = field.split(':')[0] %}
                {% set original_name = field.split(':')[1] %}
            {% else %}
                {% set mapped_name = field %}
                {% set original_name = field %}
            {% endif %}
            '"{{mapped_name}}": "' || coalesce(trim({{original_name}}), '') || '"' {% if not loop.last %} || ',' || {% endif %}
        {% endfor %}
         || '}'::varchar({{size}})
{%- endmacro -%}