{{ config(
    materialized='table'
) }}
select
{{ dbt_utils.generate_surrogate_key(['patient_id']) }} as patient_sk,
sp.patient_id,
sp.first_name,
sp.last_name,
sp.email,
sp.gender,
sp.city,
count(*) as total_appointments,
max(sp.updated_at) as last_updated
from {{ source('mart', 'stg_patients') }} sp 
inner join 
{{ source('mart', 'stg_plan_tiers') }} pt
on sp.plan_id = pt.plan_id
group by
    sp.patient_id,
    sp.first_name,
    sp.last_name,
    sp.email,
    sp.gender,
    sp.city