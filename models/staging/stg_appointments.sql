with source as (
    select * from {{ source('raw', 'raw_appointments') }}
),
filtered as (
    select *
    from source
    where fee_charged >= 0
      and appointment_date is not null
),
with_valid_fk as (
    select f.*,
        upper(f.status) as status_clean
    from filtered f
    inner join {{ ref('stg_patients') }} p on p.patient_id = f.patient_id
    inner join {{ ref('stg_doctors') }}  d on d.doctor_id  = f.doctor_id
)
select
    appointment_id,
    patient_id,
    doctor_id,
    clinic_id,
    appointment_date,
    status_clean as status,
    fee_charged as appointment_fee,
    {{ generate_audit_columns() }}
from with_valid_fk