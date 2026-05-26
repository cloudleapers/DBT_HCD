{{ config(materialized='view') }}

with cleaned as (

    select
        patient_id,

        {{ clean_name('first_name') }} as first_name,
        {{ clean_name('last_name') }} as last_name,

        lower(trim(email)) as email,

        case
            when phone is null then 'Unknown'
            else phone
        end as phone,
        city,

        {{ try_to_date('date_of_birth') }} as date_of_birth,

        case
            when upper(trim(gender)) in ('M', 'MALE') then 'Male'
            when upper(trim(gender)) in ('F', 'FEMALE') then 'Female'
            else 'Unknown'
        end as gender,

        case
            when plan_id is null then 0
            else plan_id 
        end as plan_id,
        updated_at,
        
        {{ generate_audit_columns() }}
    from {{ source('raw', 'raw_patients') }}

)

select *
from cleaned

where lower(first_name) != 'test'
  and email like '%@%.%'
  and email not like '%@@%'
  and date_of_birth is not null

qualify row_number() over (
    partition by email
    order by patient_id
) = 1