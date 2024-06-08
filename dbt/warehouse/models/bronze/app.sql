{{ config(
    materialized='incremental',
    unique_key='id',
    on_schema_change='append_new_columns',
) }}
with source_data as (
    select
        *,
        CURRENT_TIMESTAMP as last_updated_at,
        '{{ invocation_id }}'::uuid as batch_uuid
    from {{ source('app', 'my_table') }}

    {% if is_incremental() %}
    where created_at >= (select max(created_at) from {{ this }})
    {% endif %}
)
select * from source_data

