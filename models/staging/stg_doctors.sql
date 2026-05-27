 --  doctor_id        INTEGER PRIMARY KEY,
  --  doctor_name      VARCHAR(100),
  --  specialization   VARCHAR(80),
   -- clinic_id        INTEGER,
  --  consultation_fee NUMERIC(10,2),
  --  is_available     VARCHAR(5),
   -- updated_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP

with source as ( select * from {{ source('raw', 'RAW_DOCTORS') }} ),
cleaned as (
select
doctor_id,
{{ trim_whitespace('doctor_name') }} as doctor_name,
{{ clean_name('specialization') }} as specialization,
clinic_id,
{{ fee_band('consultation_fee') }} as fee_range,
consultation_fee,
{{ convert_boolean('is_available') }} as is_available,
updated_at,
{{ generate_audit_columns() }}
from source
)
select * from cleaned 
where consultation_fee >= 0

