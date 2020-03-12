{% set fields=['my_custom_field', 'better_name:field2'] %}

with cte as (
    select 'my custom value' as my_custom_field,
        'value 2' as field2
)
select {{ build_json(fields) }} as example
from cte