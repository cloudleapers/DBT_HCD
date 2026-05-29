with dim_spend as(
    select patient_id, patient_name, total_spend
    from {{ ref('dim_patients') }}
),
fct_paid as(
    select patient_id, total_paid
    from {{ ref('fct_appointments') }}
)
select
    d.patient_id,
    d.patient_name,
    d.total_spend,
    f.total_paid
    from dim_spend d
    inner join fct_paid f
        on d.patient_id = f.patient_id
    where d.total_spend != f.total_paid