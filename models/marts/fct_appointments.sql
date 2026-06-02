with appointment_payments as (

    select
        {{ dbt_utils.generate_surrogate_key(['a.appointment_id']) }} as ap_sk,
        {{ dbt_utils.generate_surrogate_key(['a.patient_id']) }} as pt_sk,
        a.appointment_id,
        a.appointment_date,
        a.st_status,
        a.appointment_fee,
        a.patient_id,
        a.patient_name,
        a.plan_id,
        a.doctor_id,
        a.doctor_name,
        a.specialization,
        a.fee_band,
        coalesce(sum(p.amount_cents) / 100.0, 0) as total_amt
    from {{ ref('int_appointment_enriched') }} a
    left join {{ ref('payments') }} p
        on p.appointment_id = a.appointment_id
       and p.amount_cents > 0
    group by
        a.appointment_id,
        a.appointment_date,
        a.st_status,
        a.appointment_fee,
        a.patient_id,
        a.patient_name,
        a.plan_id,
        a.doctor_id,
        a.doctor_name,
        a.specialization,
        a.fee_band

)

select
    ap_sk,
    appointment_id,
    appointment_date,
    st_status,
    appointment_fee,
    patient_id,
    patient_name,
    plan_id,
    doctor_id,
    doctor_name,
    specialization,
    fee_band,
    total_amt,
    current_timestamp() as _model_run_at,
    '{{ invocation_id }}' as _dbt_run_id
from appointment_payments