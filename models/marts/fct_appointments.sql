{{ config(materialized='table') }}

with payments as (

    select
        appointment_id,
        sum(amount_cents) / 100 as total_paid

    from {{ source('raw', 'raw_payments') }}
    where amount_cents > 0
    group by appointment_id

)

select

    {{ dbt_utils.generate_surrogate_key(['a.appointment_id']) }} as appointment_sk,

    a.appointment_id,
    a.patient_id,
    a.doctor_id,
    a.clinic_id,

    a.first_name,
    a.last_name,
    a.doctor_name,
    a.specialization,

    a.appointment_date,
    a.appointment_type,
    a.status,
    a.fee_charged,

    p.total_paid,

    {{ generate_audit_columns() }}

from {{ ref('int_appointment_enriched') }} a

left join payments p
    on a.appointment_id = p.appointment_id