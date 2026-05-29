select * from {{ ref('fct_appointments') }}
where fee_charged < 0