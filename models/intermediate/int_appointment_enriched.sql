{{ config(materialized='ephemeral') }}

select

    -- Appointment Details
    ap.appointment_id,
    ap.appointment_date,
    ap.appointment_type,
    ap.status,
    ap.fee_charged,
    ap.clinic_id,
    ap.updated_at,

    -- Patient Details
    p.patient_id,
    p.patient_name,
    p.email,
    p.phone,
    p.city,
    p.gender,
    p.plan_id,

    -- Doctor Details
    d.doctor_id,
    d.doctor_name,
    d.specialization,
    d.consultation_fee,
    d.fee_band
from {{ ref('stg_appointments') }} ap

left join {{ ref('stg_patients') }} p
    on ap.patient_id = p.patient_id

left join {{ ref('stg_doctors') }} d
    on ap.doctor_id = d.doctor_id