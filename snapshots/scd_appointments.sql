{% snapshot scd_appointments %}
{{
    config(
      target_database='DBT_HCD',
      target_schema='snapshots',
      unique_key='appointment_id',
      strategy='timestamp',
      updated_at='updated_at'
    )
}}

select * from {{ source('raw', 'raw_appointments') }}

{% endsnapshot %}