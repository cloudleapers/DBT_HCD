{% snapshot scd_insurance_plans %}

{{
    config(
        target_schema='snapshots',
        unique_key='plan_id',
        strategy='check',
        check_cols=['is_active', 'monthly_cost', 'tier']
    )
}}

select * from {{ ref('stg_insurance_plan') }}

{% endsnapshot %}