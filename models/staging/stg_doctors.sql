with source as (
    select * from {{ source('raw', 'raw_doctors') }}
)
select
    doctor_id,
    {{ trim_whitespace('doctor_name') }}     as doctor_name,
    specialization,
    clinic_id,
    case
        when upper(is_available::varchar) in ('Y','TRUE','1') then true
        else false
    end                                       as is_available,
    consultation_fee,
    {{ fee_band('consultation_fee') }}        as fee_band,
    {{ generate_audit_columns() }}
from source
where consultation_fee >= 0         