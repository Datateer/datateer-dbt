-- creates a model in the data warehouse that captures the
-- timestamp of the last successful dbt run. Use case is a 
-- DbtTask in the prefect orchestration that runs after 
-- dbt test.
{% if flags.prod %}
select current_timestamp as last_successful_prod_run
{% else %}
select null as last_successful_prod_run
{% endif %}