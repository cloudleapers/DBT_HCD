{% snapshot scd_doctors %}

{{
    config(
        target_schema='SNAPSHOTS',
        unique_key='doctor_id',
        strategy='check',
        check_cols=[
            'consultation_fee',
            'is_available',
            'clinic_id',
            'updated_at'
        ]
    )
}}

select
    doctor_id,
    doctor_name,
    specialization,
    clinic_id,
    consultation_fee,
    is_available,
    updated_at

from {{ source('raw', 'RAW_DOCTORS') }}

{% endsnapshot %}