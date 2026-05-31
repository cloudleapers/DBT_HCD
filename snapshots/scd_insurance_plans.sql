{% snapshot scd_insurance_plans %}
{{
  config(
    target_schema='snapshots',
    unique_key='plan_id',
    strategy='check',
    check_cols=['monthly_cost', 'is_active', 'tier']
  )
}}
select * from {{ source('raw', 'raw_insurance_plans') }}
{% endsnapshot %}