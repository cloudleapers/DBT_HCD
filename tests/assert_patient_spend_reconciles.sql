select d.patient_id
from {{ ref('dim_patients') }} d
join (
    select patient_id, sum(appointment_fee) as fact_total
    from {{ ref('fct_appointments') }}
    group by 1
) f on f.patient_id = d.patient_id
where abs(d.total_spend - f.fact_total) > 0.01