{% snapshot scd_insurance_plans %}

{{
    config(
      target_database='DBT_HCD',
      target_schema='snapshots',
      unique_key='plan_id',
      strategy='check',
      check_cols=['tier', 'monthly_cost', 'is_active']
    )
}}

select * from {{ source('raw', 'raw_insurance_plans') }}

{% endsnapshot %}