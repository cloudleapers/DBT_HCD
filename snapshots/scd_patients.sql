{% snapshot scd_patients %}

{{
    config(
        target_schema='SNAPSHOTS',
        unique_key='patient_id',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}

select
    patient_id,
    first_name,
    last_name,
    email,
    phone,
    city,
    date_of_birth,
    gender,
    plan_id,
    updated_at

from {{ source('raw', 'RAW_PATIENTS') }}

{% endsnapshot %}