{{ config(materialized='view') }}

with stg_patients as (

    select patient_id
    from {{ ref('stg_patients') }}

),

stg_doctors as (

    select doctor_id
    from {{ ref('stg_doctors') }}

),

cleaned as (

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

    from {{ source('raw', 'raw_appointments') }} a

    inner join stg_patients p
        on a.patient_id = p.patient_id

    inner join stg_doctors d
        on a.doctor_id = d.doctor_id

)

select *
from cleaned

where appointment_date is not null
  and fee_charged >= 0