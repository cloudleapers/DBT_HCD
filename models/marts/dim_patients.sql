select
    {{ dbt_utils.generate_surrogate_key(['p.patient_id']) }} as patient_sk,
    p.patient_id,
    p.first_name,
    p.last_name,
    p.email,
    p.date_of_birth,
    p.gender,
    p.plan_id,
    pt.plan_name,
    pt.tier,
    pt.tier_rank,
    count(a.appointment_id)                  as total_appointments,
    coalesce(sum(a.appointment_fee), 0)      as total_spend,
    {{ generate_audit_columns() }}

from {{ ref('stg_patients') }} p
left join {{ ref('stg_appointments') }} a on a.patient_id = p.patient_id
left join HEALTHCARE.PUBLIC.PLAN_TIERS pt on pt.plan_id = p.plan_id  
group by 1,2,3,4,5,6,7,8,9,10,11