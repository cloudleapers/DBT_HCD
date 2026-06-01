{{ config(materialized='table') }}

with appointment_enriched as (
    select * from {{ ref('int_appointment_enriched') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['appointment_id']) }}  as appointment_sk,
    {{ dbt_utils.generate_surrogate_key(['patient_id']) }}      as patient_sk,

    appointment_id,
    patient_id,
    doctor_id,
    clinic_id,

    patient_name,
    gender,
    doctor_name,
    specialization,
    fee_band                                                    as doctor_fee_band,

    appointment_date,
    appointment_type,
    status,

    -- financial measures
    fee_charged,
    coalesce(total_paid, 0)                                     as total_paid,
    fee_charged - coalesce(total_paid, 0)                       as outstanding_amount,

    -- boolean flag
    case
        when coalesce(total_paid, 0) >= fee_charged then true
        else false
    end                                                         as is_fully_paid,

    payment_method,
    paid_at,

    {{ generate_audit_columns() }}

from appointment_enriched