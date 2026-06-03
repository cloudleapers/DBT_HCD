{% snapshot scd_clinics %}

{{
    config(
        target_schema='SNAPSHOTS',
        unique_key='clinic_id',
        strategy='check',
        check_cols=[
            'city',
            'is_operational'
        ]
    )
}}

select
    clinic_id,
    clinic_name,
    city,
    state,
    is_operational,
    opened_date,
    updated_at

from {{ source('raw', 'RAW_CLINICS') }}

{% endsnapshot %}