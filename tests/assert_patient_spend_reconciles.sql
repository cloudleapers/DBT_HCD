
with

dim_spend as (

    select
        patient_id,
        total_spend             as dim_total_spend

    from {{ ref('dim_patients') }}

),

fct_spend as (

    select
        patient_id,
        sum(fee_charged)        as fct_total_spend

    from {{ ref('fct_appointments') }}

    group by patient_id

),

comparison as (

    select
        d.patient_id,
        d.dim_total_spend,
        coalesce(f.fct_total_spend, 0)      as fct_total_spend,

        abs(
            coalesce(d.dim_total_spend, 0)
            - coalesce(f.fct_total_spend, 0)
        )                                   as difference

    from dim_spend d

    
    left join fct_spend f
        on d.patient_id = f.patient_id

)

select
    patient_id,
    dim_total_spend,
    fct_total_spend,
    difference
from comparison
where difference > 0.01