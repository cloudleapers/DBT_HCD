{{ config(materialization='view') }}

with appointments as (
select * from {{ source('raw', 'RAW_APPOINTMENTS') }}
)
select
    a.appointment_id,
    a.patient_id,
    a.doctor_id,
    a.clinic_id,
    a.appointment_date,
    a.appointment_type,
    upper(trim(a.status)) as status,
    a.fee_charged,
    a.updated_at,
    {{ generate_audit_columns() }}
from appointments a
inner join {{ ref('stg_patients') }} p
    on a.patient_id = p.patient_id
inner join {{ ref('stg_doctors') }} d
    on a.doctor_id = d.doctor_id
where a.appointment_date is not null
  and a.fee_charged >=0

qualify row_number() over (
    partition by a.patient_id
    order by  a.appointment_id desc
) = 1
order by a.appointment_id asc