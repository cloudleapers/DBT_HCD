{{ config(materialized='view') }}
with patients as (
select
patient_id,
{{ clean_name('first_name') }} as first_name,
{{ clean_name('last_name') }} as last_name,
lower(trim(email)) as email,
{{ remove_special_chars('phone', 'digits') }} as phone,
city,
{{ try_to_date('date_of_birth') }} as date_of_birth,
{{ gender('gender') }} as gender,
plan_id,
updated_at,
{{ generate_audit_columns() }}
from {{ source('raw', 'RAW_PATIENTS') }}
where email is not null
    and lower(trim(email)) not like '%@@%'
    and lower(trim(email)) not like '%test%'
)
select * from patients

qualify row_number() over (
    partition by email
    order by  updated_at desc
) = 1
order by patient_id asc