{{ config(materialized='view') }}

with cleaned as (

    select
        doctor_id,

        {{ trim_whitespace('doctor_name') }} as doctor_name,

        specialization,
        clinic_id,
        consultation_fee,

        {{ fee_band('consultation_fee') }} as fee_band,

        case
            when upper(trim(is_available)) in ('Y', '1', 'YES', 'TRUE') then true
            when upper(trim(is_available)) in ('N', '0', 'NO', 'FALSE') then false
            else null
        end as is_available,

        updated_at,

        {{ generate_audit_columns() }}

    from {{ source('raw', 'raw_doctors') }}

)

select *
from cleaned

where consultation_fee >= 0
  and upper(trim(specialization)) != 'TEST'