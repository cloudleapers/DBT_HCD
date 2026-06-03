select * from {{ source('stage', 'stg_appointments') }}
where fee_charged < 0