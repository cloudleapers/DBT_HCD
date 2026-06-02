{{ config(
    materialized='ephemeral'
) }}
with patients as (

    select *
    from {{ ref('stg_patients') }}

),
appointments as (

    select *
    from {{ ref('stg_appointments') }}

),

plan_tiers as (

    select *
    from {{ ref('stg_plan_tiers') }}

)

select
{{ dbt_utils.generate_surrogate_key(['p.patient_id']) }} as patient_sk,
p.patient_id,
p.first_name,
p.last_name,
p.email,
p.gender,
p.city,
p.plan_id,
pt.plan_name,
pt.tier,
pt.tier_rank,
count(a.appointment_id) as total_appointments,
max(a.appointment_date) as last_appointment_date
from patients p
left join appointments a
on p.patient_id = a.patient_id
inner join plan_tiers pt
on p.plan_id = pt.plan_id
group by
p.patient_id,
p.first_name,
p.last_name,
p.email,
p.gender,
p.city,
p.plan_id,
pt.plan_name,
pt.tier,
pt.tier_rank
order by p.patient_id