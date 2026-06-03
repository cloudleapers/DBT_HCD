with dim_spend as (

    select
        patient_id,
        total_fees_paid
    from {{ ref('dim_patients') }}

),

fact_spend as (

    select
        patient_id,
        sum(total_amount) as fact_total_fees_paid
    from {{ ref('fct_appointments') }}
    group by patient_id

)

select
    d.patient_id,
    d.total_fees_paid,
    coalesce(f.fact_total_fees_paid, 0) as fact_total_fees_paid
from dim_spend d
left join fact_spend f
    on d.patient_id = f.patient_id
where abs(
    coalesce(d.total_fees_paid, 0)
    - coalesce(f.fact_total_fees_paid, 0)
) > 0.01