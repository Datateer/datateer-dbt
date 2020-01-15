{#-
  Creates created_at and updated_at for an incremental model
-#}
{%- macro sys_columns() -%}
    {%- if is_incremental() -%}
    coalesce(target.created_at, current_timestamp) as created_at,
    coalesce(target.created_by, current_user) as created_by,
    {%- else -%}
    current_timestamp as created_at,
    current_user as created_by,
    {%- endif %}
    current_timestamp as updated_at,
    current_user as updated_by
{%- endmacro -%}