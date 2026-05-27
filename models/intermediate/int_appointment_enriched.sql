{{ config(
    materialized='ephemeral'
) }}

select
a.appointment_id,
a.appointment_date,
a.status,
p.patient_id,
p.first_name,
p.last_name,
p.gender,
d.doctor_id,
d.doctor_name,
d.specialization,
d.fee_range,
py.amount_cents
from {{ source('stg','stg_appointments') }} a
inner join {{ source('stg','stg_patients') }} p
on a.patient_id=p.patient_id
inner join {{ source('stg','stg_doctors') }} d
on a.doctor_id=d.doctor_id
inner join {{ source('stg','stg_payments') }} py
on a.appointment_id=py.appointment_id
