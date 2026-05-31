select
    {{ dbt_utils.generate_surrogate_key(['a.appointment_id']) }} as appointment_sk,
    a.appointment_id,
    a.appointment_date,
    a.status,
    a.appointment_fee,
    a.patient_id,
    a.patient_name,
    a.plan_id,
    a.doctor_id,
    a.doctor_name,
    a.specialization,
    a.fee_band,
    coalesce(sum(pay.amount_cents) / 100.0, 0) as total_paid_usd,
    {{ generate_audit_columns() }}
from {{ ref('int_appointment_enriched') }} a
left join {{ source('raw', 'raw_payments') }} pay on pay.appointment_id = a.appointment_id
                                              and pay.amount_cents > 0
group by 1,2,3,4,5,6,7,8,9,10,11,12