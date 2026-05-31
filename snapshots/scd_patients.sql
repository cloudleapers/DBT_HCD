{% snapshot scd_patients %}
{{
  config(
    target_schema='snapshots',
    unique_key='patient_id',
    strategy='timestamp',
    updated_at='updated_at'
  )
}}
select * from {{ source('raw', 'raw_patients') }}
{% endsnapshot %}