{{ config(materialized='table') }}

with appointment_enriched as (
    select * from {{ ref('int_appointment_enriched') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['patient_id']) }} as patient_sk,
    patient_id,
    patient_name,
    gender,
    phone,
    city,

    plan_id,
    plan_name,
    plan_tier,

    appointment_id,
    appointment_type,
    status,
    total_appointments,
    first_appointment_date,
    last_appointment_date,
    total_spend,
    fee_charged -- Removed trailing comma

from appointment_enriched
