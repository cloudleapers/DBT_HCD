{{ config(materialized='ephemeral') }}

with appointments as 
(
select 
    a.appointment_id,
    a.patient_id,
    concat({{ clean_name('p.first_name') }},' ',{{ clean_name('p.last_name') }}) as patient_name,
    p.gender,
    p.city,
    a.doctor_id,
    d.doctor_name,
    d.specialization,
    a.clinic_id,
    a.appointment_date,
    a.appointment_type,
    a.status,
    a.fee_charged,
    py.amount_cents,
    a.updated_at,
    {{ generate_audit_columns() }}
    from {{ref('stg_appointments') }} a
    left join {{ ref('stg_patients') }} p
        on a.patient_id = p.patient_id
    left join {{ ref('stg_doctors') }} d
        on a.doctor_id = d.doctor_id
    left join {{ ref('stg_payments') }} py
        on a.appointment_id = py.appointment_id
)
select * from appointments
