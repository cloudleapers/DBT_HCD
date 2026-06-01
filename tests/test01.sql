select a.patient_id
from {{ ref('dim_patients') }} a
join (
    select patient_id, sum(appointment_fee) as fct_total
    from {{ ref('fct_appointments') }} b
    group by 1
) f on b.patient_id = a.patient_id
where abs(d.total_spend - b.fact_total) > 0.01