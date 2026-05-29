{% snapshot scd_appointments %}
{{
    config(
        target_schema='snapshots',
        unique_key='appointment_id',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}

select * from {{ ref('stg_appointments') }}

{% endsnapshot %}