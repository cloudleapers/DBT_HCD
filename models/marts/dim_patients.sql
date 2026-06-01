{{ config(materialized='table') }}

with appointment_enriched as (
    select * from {{ ref('int_appointment_enriched') }}
),

deduped as (
    select *
    from appointment_enriched
    qualify row_number() over (
        partition by patient_id
        order by appointment_date asc
    ) = 1
)

select
    {{ dbt_utils.generate_surrogate_key(['patient_id']) }}  as patient_sk,
    patient_id,
    patient_name,
    gender,
    phone,
    city,

    plan_id,
    plan_name,
    coalesce(plan_tier, 'NONE')                         as plan_tier,

    -- patient-level metrics (safe NULLs)
    coalesce(total_appointments, 0)                         as total_appointments,
    coalesce(total_spend, 0)                                as total_spend,
    first_appointment_date,
    last_appointment_date,

    {{ generate_audit_columns() }}

from deduped