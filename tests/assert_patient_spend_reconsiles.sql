with dim_spend as(
    select patient_id, total_fees
    from {{ ref('dim_patients') }}
),
fct_paid as(
    select patient_id,
     sum(fee_charged) as fact_total_fees
    from {{ ref('fct_appointments') }}
    group by patient_id
)
select
    d.patient_id,
    d.total_fees,
    f.fact_total_fees
    from dim_spend d
    inner join fct_paid f
        on d.patient_id = f.patient_id
    where d.total_fees != f.fact_total_fees
