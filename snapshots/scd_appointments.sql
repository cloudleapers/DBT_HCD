{% snapshot scd_appointments %}

{{
    config(
        target_schema='SNAPSHOTS',
        unique_key='appointment_id',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}

select
    appointment_id,
    patient_id,
    doctor_id,
    clinic_id,
    appointment_date,
    appointment_type,
    status,
    fee_charged,
    updated_at

from {{ source('raw', 'RAW_APPOINTMENTS') }}

{% endsnapshot %}