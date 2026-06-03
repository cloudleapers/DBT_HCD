{{ config(materialized='ephemeral') }}

select
    a.appointment_id,
    a.appointment_date,
    a.appointment_type,
    a.st_status,
    a.appointment_fee,
    a.clinic_id,
    p.patient_id,
    p.first_name,
    p.last_name,
    p.gender,
    p.plan_id,
    d.doctor_id,
    d.doctor_name,
    d.specialization,
    d.consultation_fee,
    d.fee_band,
    pay.amount_cents,
    pay.payment_method,
    pay.paid_at,
    concat(p.first_name, ' ', p.last_name) as patient_name,

    {{ generate_audit_columns() }}

from {{ ref('stg_appointments') }} a

left join {{ ref('stg_patients') }} p
    on a.patient_id = p.patient_id

inner join {{ ref('stg_doctors') }} d
    on a.doctor_id = d.doctor_id

left join {{ ref('stg_payments') }} pay
    on a.appointment_id = pay.appointment_id