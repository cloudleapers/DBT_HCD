{{ config(schema='STAGING') }}

with doctors_cleaned as (

    select
        d.doctor_id,
        {{ trim_whitespace('d.doctor_name') }} as doctor_name,
        d.specialization,
        d.clinic_id,
        d.consultation_fee,
        cl.city,
        cl.clinic_name,
        cl.is_operational,
        case
            when lower(d.is_available) in ('Y', '1') then true
            when lower(d.is_available) in ('N', '0') then false
            else null
        end as is_available,
        d.updated_at,
    from {{ source('raw', 'RAW_DOCTORS') }} d
    inner join {{source('raw','RAW_CLINICS')}} cl
        on d.clinic_id = cl.clinic_id
    where d.consultation_fee >= 0
      and lower(trim(d.doctor_name)) <> 'test'
      and cl.opened_date != 'INVALID'
)

select * from doctors_cleaned