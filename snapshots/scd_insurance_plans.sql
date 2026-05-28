{% snapshot scd_insurance_plans %}

{{
    config(
        target_schema='snapshots',
        unique_key='plan_id',
        strategy='check',
        check_cols=['is_active', 'monthly_cost', 'tier']
    )
}}

select * from {{ source('inter', 'STG_INSURANCE_PLANS') }}

{% endsnapshot %}