{#- 
Left joins a query to the target table of the dbt model using client_id. 
client_table_alias is the alias referencing dim_clients so that they join can be done
client_table_id_column is the name of the column that should be used to join. This is optional and can be left off but be sure you know what you are doing, because the result set could be huge
-#}
{%- macro sys_column_join(client_table_alias, client_table_id_column) %}
    {%- if is_incremental() -%} 
left join {{ this }} target 
    on target.client_id = {{client_table_alias}}.client_id
    {%- if client_table_id_column is defined %}
    and target.{{client_table_id_column}} = {{client_table_alias}}.{{client_table_id_column}}
        {%- endif %}
    {%- endif -%}
{%- endmacro -%}