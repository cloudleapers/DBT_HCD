{{ config(materialized='table') }}

select
    md5(cast(appointment_id as varchar)) as appointment_sk,

    appointment_id,
    appointment_date,
    patient_id,
    patient_name,
    status,
    clinic_id,
    gender,
    doctor_id,
    doctor_name,
    specialization,
    fee_charged,
    round(amount_cents/ 100,2) as patient_total_paid,
    updated_at
from {{ ref('int_appointment_enriched') }}