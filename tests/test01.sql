select a.patient_id
from {{ ref('dim_patients') }} a

join (
    select
        patient_id,
        sum(appointment_fee) as fct_total
    from {{ ref('fct_appointments') }}
    group by patient_id
) f
on f.patient_id = a.patient_id

where abs(coalesce(a.total_spend,0) - f.fct_total) > 0.01