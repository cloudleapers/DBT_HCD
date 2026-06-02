{% snapshot snapshot_patient %}
{{
  config(
    target_schema='snapshots',
    unique_key='patient_id',
    strategy='timestamp',
    updated_at='updated_at'
  )
}}
select * from {{ ref('patients') }}
{% endsnapshot %}