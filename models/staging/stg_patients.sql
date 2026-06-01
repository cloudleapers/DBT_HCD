with source as (
select * from {{ source('raw', 'RAW_PATIENTS') }}
),
cleaned as (
select
patient_id,
{{ clean_name('first_name') }} as first_name,
{{ clean_name('last_name') }} as last_name,
lower(trim(email)) as email,
{{ remove_special_chars('phone','digits') }} as phone,
{{ clean_name('city') }} as city,
{{ safe_date('date_of_birth') }} as date_of_birth,
case
when upper(gender) in ('M','MALE')
then 'MALE'
when upper(gender) in ('F','FEMALE')
then 'FEMALE'
else 'UNKNOWN'
end as gender,
plan_id,
updated_at,
{{ generate_audit_columns() }}
from source
where lower(trim(email)) not like '%@@%.%' 
and upper(trim(first_name)) != 'TEST'
)
select *  from cleaned
qualify row_number()
over(
    partition by lower(email)
    order by updated_at desc
)=1