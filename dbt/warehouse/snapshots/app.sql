{% snapshot app_snapshot %}

{{ config(
    unique_key='id',
    target_database='postgres',
    target_schema='snapshots',
    strategy='timestamp',
    updated_at='created_at',
) }}
with source_data as (
    select
        *,
        '{{ invocation_id }}'::uuid as batch_uuid
    from {{ source('app', 'my_table') }}
)

select * from source_data

{% endsnapshot %}
