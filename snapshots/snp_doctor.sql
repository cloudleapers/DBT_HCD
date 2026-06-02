{% snapshot snp_doctor %}
{{
  config(
    target_schema='snapshots',
    unique_key='doctor_id',
    strategy='timestamp',
    updated_at='updated_at'
  )
}}
select * from {{ ref('doctors') }}
{% endsnapshot %}