-- models/stage/stg_doctors.sql
{{ config(materialization='view') }}

select
    doctor_id,
    {{ trim_whitespace('doctor_name') }} as doctor_name,
    specialization,
    clinic_id,
    consultation_fee,
    case 
        when lower(is_available) in ('y', '1') then true
        when lower(is_available) in ('n', '0') then false
        else null
    end as is_available,
    updated_at
from {{ source('raw', 'RAW_DOCTORS') }}
where consultation_fee >= 0
  and lower(trim(doctor_name)) <>'test'