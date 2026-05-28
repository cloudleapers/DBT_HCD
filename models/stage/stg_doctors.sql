{{ config(materialization='view') }}

with doctors as (
select
    doctor_id,
    {{ trim_whitespace('doctor_name') }} as doctor_name,
    specialization,
    clinic_id,
    consultation_fee,
    {{available('is_available')}} as is_available,
    updated_at,
    {{ generate_audit_columns() }}
    from {{ source('raw', 'RAW_DOCTORS') }}
        where consultation_fee >= 0
        and lower(trim(doctor_name)) <> 'test'
)
select * from doctors