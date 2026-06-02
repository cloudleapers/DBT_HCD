{{ config(
    materialized='ephemeral'
) }}

with appointments as (

    select *
    from {{ ref('stg_appointments') }}

),
patients as (

    select *
    from {{ ref('stg_patients') }}

),
doctors as (

    select *
    from {{ ref('stg_doctors') }}

),
payments as (

    select *
    from {{ ref('stg_payments') }}

)


select
a.appointment_id,
a.appointment_date,
a.status,
p.patient_id,
concat(p.first_name, ' ', p.last_name) as patient_name,
p.gender,
d.doctor_id,
d.doctor_name,
d.specialization,
d.fee_range,
py.amount_cents,
py.payment_method,
py.paid_at,
py.updated_at,
{{ generate_audit_columns() }}
from appointments a
inner join patients p
on a.patient_id=p.patient_id
inner join doctors d
on a.doctor_id=d.doctor_id
inner join payments py
on a.appointment_id=py.appointment_id
