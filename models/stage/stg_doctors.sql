select
    doctor_id,
    {{ clean_name('doctor_name') }}             as doctor_name,
    clinic_id,
    round(cast(consultation_fee as number(10,2)), 2) as consultation_fee,
    {{ fee_band('consultation_fee') }}          as fee_band,
    trim(specialization)                        as specialization

from {{ source('raw', 'DOCTORS') }}

where doctor_id is not null
  and consultation_fee > 0