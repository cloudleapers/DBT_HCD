-- appointment_id   INTEGER PRIMARY KEY,
  --  patient_id       INTEGER,
   -- doctor_id        INTEGER,
   -- clinic_id        INTEGER,
   -- appointment_date DATE,
--appointment_type VARCHAR(30),
  --  status           VARCHAR(20),
---fee_charged      NUMERIC(10,2),
--updated_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP

with appointments as (

select * from {{ source('raw','RAW_APPOINTMENTS') }}
),
patients as (
select * from {{ ref('stg_patients') }}
),

doctors as (
select * from {{ ref('stg_doctors') }}
),
payments as ( select * from {{ref('stg_payments') }} 
)

select
a.appointment_id,
a.patient_id,
a.doctor_id,
a.clinic_id,
a.appointment_date,
upper(trim(a.status)) as status,
py.amount_cents,
{{ generate_audit_columns() }}
from appointments a
inner join patients p
on a.patient_id=p.patient_id
inner join doctors d
on a.doctor_id=d.doctor_id
inner join payments py
on a.appointment_id=py.appointment_id
where a.appointment_date is not null
and py.amount_cents >= 0

