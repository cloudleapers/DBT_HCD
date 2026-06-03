{% snapshot scd_insurance_plans %}

{{
    config(
        target_schema='SNAPSHOTS',
        unique_key='plan_id',
        strategy='check',
        check_cols=[
            'tier',
            'monthly_cost',
            'is_active'
        ]
    )
}}

select
    plan_id,
    plan_name,
    tier,
    monthly_cost,
    is_active,
    updated_at

from {{ source('raw', 'RAW_INSURANCE_PLANS') }}

{% endsnapshot %}