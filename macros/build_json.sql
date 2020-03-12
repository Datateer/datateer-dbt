{#-
  Builds a flat json structure and returns it as a varchar
-#}
{%- macro build_json(fields, size=5000) -%}
        '{' || 
        {% for field in fields %}
            '"{{field}}": "' || coalesce(trim({{field}}), '') || '"' {% if not loop.last %} || ',' || {% endif %}
        {% endfor %}
         || '}'::varchar({{size}})
{%- endmacro -%}