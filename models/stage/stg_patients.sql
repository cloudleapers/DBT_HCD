select
    patient_id,
    {{ clean_name('first_name') }}              as first_name,
    {{ clean_name('last_name') }}               as last_name,
    lower(trim(email))                          as email,
    plan_id

from {{ source('raw', 'PATIENTS') }}

where patient_id is not null
  and email is not null
  and trim(email) like '%@%.%'