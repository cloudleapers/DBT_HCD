{{ config(materialized='ephemeral', schema='INTERMEDIATE') }}

with intermediate_eph as (

    select
        ap.appointment_id,
        ap.patient_id,
        ap.doctor_id,
        ap.clinic_id,
        ap.plan_id,
        ap.appointment_date,
        ap.appointment_type,
        ap.status,
        ap.fee_charged,
        ap.updated_at as appointment_updated_at,
        p.first_name,
        p.last_name,
        p.email,
        p.phone,
        p.city as patient_city,
        p.date_of_birth,
        p.gender,
        p.updated_at as patient_updated_at,
        d.doctor_name,
        d.specialization,
        d.consultation_fee,
        d.city as doctor_city,
        d.clinic_name,
        d.is_operational,
        d.is_available,
        d.updated_at as doctor_updated_at
    from {{ ref('stg_apointments') }} ap
    left join {{ ref('stg_patients') }} p
        on ap.patient_id = p.patient_id
    left join {{ ref('stg_doctors') }} d
        on ap.doctor_id = d.doctor_id
)
select *
from intermediate_eph