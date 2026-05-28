{{ config(materialized='table') }}

with patient_metrics as (

    select
        patient_id,
        count(*) as total_appointments,
        min(appointment_date) as first_appointment_date,
        max(appointment_date) as last_appointment_date,
        sum(fee_charged) as total_spend

    from {{ source('stg', 'stg_appointments') }}

    group by patient_id

),
plan as (

    select *
    from {{ source('raw', 'plan_tiers') }}

)

select

    {{ dbt_utils.generate_surrogate_key(['p.patient_id']) }} as patient_hk,

    p.patient_id,
    p.first_name,
    p.last_name,
    p.phone,

    pl.plan_name,
    pl.tier as plan_tier,

    pm.total_appointments,
    pm.first_appointment_date,
    pm.last_appointment_date,
    pm.total_spend,

    {{ generate_audit_columns() }}

from {{ source('stg', 'stg_patients') }} p

left join patient_metrics pm
    on p.patient_id = pm.patient_id

left join plan pl
    on p.plan_id = pl.plan_id