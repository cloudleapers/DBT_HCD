{{ config(
    materialized='table'
) }}
select
{{ dbt_utils.generate_surrogate_key(['patient_id']) }} as patient_sk,
patient_id,
first_name,
last_name,
email,
gender,
city,
count(*) as total_appointments,
max(updated_at) as last_updated
from {{ source('mart', 'stg_patients') }}
group by
    patient_id,
    first_name,
    last_name,
    email,
    gender,
    city