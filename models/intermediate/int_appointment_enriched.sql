select
    a.appointment_id,
    a.appointment_date,
    a.status,
    a.appointment_fee,
    a.clinic_id,
    p.patient_id,
    p.first_name || ' ' || p.last_name       as patient_name,
    p.email,
    p.plan_id,
    d.doctor_id,
    d.doctor_name,
    d.specialization,
    d.fee_band
from {{ ref('stg_appointments') }} a
left join {{ ref('stg_patients') }} p on p.patient_id = a.patient_id
left join {{ ref('stg_doctors') }} d on d.doctor_id  = a.doctor_id