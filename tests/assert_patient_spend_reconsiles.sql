select
    d.patient_id,
    d.total_fees,
    sum(f.fee_charged) as fact_total_fees
from {{ ref('dim_patients') }} d
join {{ ref('fct_appointments') }} f
    on d.patient_id = f.patient_id
group by
    d.patient_id,
    d.total_fees
having d.total_fees != fact_total_fees