{% snapshot snp_appointment %}
{{
  config(
    target_schema='snapshots',
    unique_key='appointment_id',
    strategy='timestamp',
    updated_at='updated_at'
  )
}}
select * from {{ ref('appointments') }}
{% endsnapshot %}