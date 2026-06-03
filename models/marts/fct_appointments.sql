{{ config(
    materialized='table',
    schema='MARTS'
) }}

with appointments as (

    select *
    from {{ ref('int_appointment_enriched') }}

),

payments as (
    select
        appointment_id,
        count(*) as payment_count,
        sum(amount_cents) as total_amount_cents,
        round(sum(amount_cents) / 100, 2) as total_amount
    from {{ source('raw', 'RAW_PAYMENTS') }}
    group by appointment_id
)

select

    {{ dbt_utils.generate_surrogate_key(['a.appointment_id']) }} as appointment_sk,
    a.appointment_id,
    a.appointment_date,
    a.appointment_type,
    a.status,
    a.fee_charged,
    a.patient_id,
    a.first_name,
    a.last_name,
    a.gender,
    a.plan_id,
    a.doctor_id,
    a.doctor_name,
    a.specialization,
    a.consultation_fee,
    a.clinic_name,
    coalesce(p.payment_count, 0) as payment_count,
    coalesce(p.total_amount_cents, 0) as total_amount_cents,
    coalesce(p.total_amount, 0) as total_amount,
    a.appointment_updated_at

from appointments a

left join payments p
    on a.appointment_id = p.appointment_id