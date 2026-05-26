select
    patient_id,
    {{ clean_name('first_name') }} as first_name,
    {{ clean_name('last_name') }} as last_name,
    concat({{ clean_name('first_name') }}, ' ', {{ clean_name('last_name') }}) as patient_name,
    lower(trim(email)) as email,
    {{ remove_special_chars('phone','digits') }} as phone,
    city,
    {{ try_to_date('date_of_birth') }} as date_of_birth,
    case 
        when lower(gender) in ('m', 'male') then 'Male'
        when lower(gender) in ('f', 'female') then 'Female'
        else 'Unknown'
    end as gender,
    plan_id,
    updated_at
from {{ source('raw', 'RAW_PATIENTS') }}
where lower(trim(email)) not like '%@@%'
  and lower(trim(email)) not like '%test%'
  and email is not null
qualify row_number() over (
    partition by lower(trim(email)) 
    order by updated_at desc
) = 1
order by patient_id asc