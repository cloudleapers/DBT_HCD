{{ config(materialized='ephemeral') }}

select
    a.appointment_id,
    a.appointment_date,
    a.appointment_type,
    a.status,
    a.fee_charged,

    p.patient_id,
    p.first_name,
    p.last_name,
    p.gender,
    p.city,
    p.plan_id,

    d.doctor_id,
    d.doctor_name,
    d.specialization,
    d.consultation_fee,
    d.fee_band,
    d.is_available,

    a.clinic_id,
    a.updated_at,

    sp.amount_cents,
    sp.payment_method,
    sp.paid_at,

    {{ generate_audit_columns() }}

from {{ ref('stg_appointments') }} a

inner join {{ ref('stg_patients') }} p
    on a.patient_id = p.patient_id

inner join {{ ref('stg_doctors') }} d
    on a.doctor_id = d.doctor_id

inner join {{ ref('stg_payments') }} sp
    on a.appointment_id = sp.appointment_id