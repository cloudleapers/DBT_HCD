{% snapshot snapshot_insurance %}
{{
  config(
    target_schema='snapshots',
    unique_key='plan_id',
    strategy='check',
    check_cols=['monthly_cost', 'is_active', 'tier']
  )
}}
select * from {{ ref('insurance_plans') }}
{% endsnapshot %}