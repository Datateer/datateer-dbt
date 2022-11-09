-- creates a model in the data warehouse that captures the
-- timestamp of the last successful dbt run. Use case is a 
-- DbtTask in the prefect orchestration that runs after 
-- dbt test.

select current_timestamp as last_successful_run_time