{{ config(materialized='ephemeral') }}

with patients as 
(
    select * from {{ref('stg_patients') }}
),
appointments as 
(
    select * from {{ ref('stg_appointments') }}
),
plan_tiers as
(
    select * from {{ ref('plan_tiers') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['p.patient_id']) }} as patient_sk,
    p.patient_id,
    concat({{ clean_name('p.first_name') }},' ',{{ clean_name('p.last_name') }}) as patient_name,
    p.email,
    p.phone,
    p.city,
    p.gender,
    pt.tier,
    count(a.appointment_id) as total_appointments,
    sum(a.fee_charged) as total_fees,
    round(avg(a.fee_charged), 2) as avg_fee,
    p.updated_at,
    {{ generate_audit_columns() }}

from patients p
left join appointments a
    on p.patient_id = a.patient_id
left join plan_tiers pt
    on p.plan_id = pt.plan_id
group by
    p.patient_id,
    p.first_name,
    p.last_name,
    p.email,
    p.phone,
    p.city,
    p.gender,
    pt.tier,
    p.updated_at
order by patient_id asc