{{ config(materialized='table') }}

with appointment_enriched as (
    select * from {{ ref('int_appointment_enriched') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['appointment_id']) }} as appointment_sk,
    {{ dbt_utils.generate_surrogate_key(['patient_id']) }} as patient_sk,
    patient_id,
    appointment_id,
    doctor_id,

    patient_name,
    gender,
    doctor_name,
    specialization,

    appointment_type,
    status,

    total_paid,
    payment_method,
    paid_at

from appointment_enriched
