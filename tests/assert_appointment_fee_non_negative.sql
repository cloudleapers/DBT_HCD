select * from {{ ref('stg_appointments') }}
where fee_charged < 0;
