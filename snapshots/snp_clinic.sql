{% snapshot snp_clinic %}
{{
  config(
    target_schema='snapshots',
    unique_key='clinic_id',
    strategy='check',
    check_cols=['is_operational', 'city', 'clinic_name']
  )
}}
select * from {{ source('raw', 'clinics') }}
{% endsnapshot %}