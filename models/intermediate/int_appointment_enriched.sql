{{ config(materialized='ephemeral') }}

with

appointments as (
    select * from {{ ref('stg_appointments') }}
),

patients as (
    select * from {{ ref('stg_patients') }}
),

doctors as (
    select * from {{ ref('stg_doctors') }}
),

payments as (
    select * from {{ source('raw', 'raw_payments') }}
),

plan_tiers as (
    select * from {{ ref('plan_tiers') }}
),


appointment_metrics as (
    select
        patient_id,
        count(appointment_id)                       as total_appointments,
        min(appointment_date)                       as first_appointment_date,
        max(appointment_date)                       as last_appointment_date,
        sum(fee_charged)                            as total_spend
    from appointments
    group by patient_id
),

payment_rollup as (
    select
        appointment_id,
        sum(amount_cents) / 100.0                   as total_paid,
        max(payment_method)                         as payment_method,
        max(paid_at)                                as paid_at
    from payments
    where amount_cents > 0
    group by appointment_id
)

select
    a.appointment_id,
    a.appointment_type,
    a.status,
    a.fee_charged,
    a.appointment_date,
    a.clinic_id,
    a.updated_at,

    p.patient_id,
    p.first_name || ' ' || p.last_name              as patient_name,
    p.gender,
    p.phone,
    p.city,
    p.plan_id,

    pl.plan_name,
    pl.tier                                         as plan_tier,

    d.doctor_id,
    d.doctor_name,
    d.specialization,
    d.consultation_fee,
    d.fee_band,
    d.is_available,

    m.total_appointments,
    m.first_appointment_date,
    m.last_appointment_date,
    m.total_spend,

    pr.total_paid,
    pr.payment_method,
    pr.paid_at,

    {{ generate_audit_columns() }}

from appointments a

left join patients p
    on a.patient_id = p.patient_id

left join doctors d
    on a.doctor_id = d.doctor_id

left join plan_tiers pl
    on p.plan_id = pl.plan_id

left join appointment_metrics m
    on a.patient_id = m.patient_id

left join payment_rollup pr
    on a.appointment_id = pr.appointment_id