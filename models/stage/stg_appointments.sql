{{ config(materialization='view') }}
select
    ap.appointment_id,
    ap.patient_id,
    ap.doctor_id,
    ap.clinic_id,
    ap.appointment_date,
    ap.appointment_type,
    upper(ap.status) as status,
    ap.fee_charged,
    ap.updated_at
from {{ source('raw', 'RAW_APPOINTMENTS') }} as ap
inner join {{ ref('stg_patients') }} as p 
    on ap.patient_id = p.patient_id
inner join {{ ref('stg_doctors') }} as d 
    on ap.doctor_id = d.doctor_id
where ap.appointment_date is not null
  and ap.fee_charged >= 0