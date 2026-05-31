select * from {{ ref('fct_appointments') }}
where appointment_fee < 0