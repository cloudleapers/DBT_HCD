select
    appointment_id,
    patient_id,
    doctor_id,
    clinic_id,
    {{ try_to_date('appointment_date') }}       as appointment_date,
    upper(trim(status))                         as st_status

from {{ source('raw', 'APPOINTMENTS') }}

where appointment_id is not null
  and appointment_date is not null
  and patient_id is not null
  and doctor_id is not null