{{ config(materialized='ephemeral') }}

-- CTE 1: Calculate metrics with a minimal GROUP BY (only 1 column!)
with appointment_metrics as (
    select
        a.appointment_id,
        count(*) as total_appointments,
        min(a.appointment_date) as first_appointment_date,
        max(a.appointment_date) as last_appointment_date,
        sum(a.fee_charged) as total_spend,
        sum(sp.amount_cents / 100) as total_paid
    from {{ source('stg', 'stg_appointments') }} a
    inner join {{ source('stg', 'stg_payments') }} sp
        on a.appointment_id = sp.appointment_id
    group by a.appointment_id
)

-- CTE 2: Pull the descriptive details without any GROUP BY needed
select
    a.appointment_id,
    a.appointment_type,
    a.status,
    a.fee_charged,
    a.appointment_date,

    p.patient_id,
    p.first_name || ' ' || p.last_name as patient_name,
    p.gender,
    p.phone,
    p.city,
    p.plan_id,

    pl.plan_name,
    pl.tier as plan_tier,

    d.doctor_id,
    d.doctor_name,
    d.specialization,
    d.consultation_fee,
    d.fee_band,
    d.is_available,

    a.clinic_id,
    a.updated_at,

    -- Bring metrics in from the first CTE
    m.total_appointments,
    m.first_appointment_date,
    m.last_appointment_date,
    m.total_spend,
    m.total_paid,

    sp.payment_method,
    sp.paid_at,

    {{ generate_audit_columns() }}

from {{ source('stg', 'stg_appointments') }} a

inner join appointment_metrics m
    on a.appointment_id = m.appointment_id

inner join {{ source('stg', 'stg_patients') }} p
    on a.patient_id = p.patient_id

inner join {{ source('stg', 'stg_doctors') }} d
    on a.doctor_id = d.doctor_id

inner join {{ source('stg', 'stg_payments') }} sp
    on a.appointment_id = sp.appointment_id

inner join {{ source('raw', 'plan_tiers') }} pl
    on p.plan_id = pl.plan_id
