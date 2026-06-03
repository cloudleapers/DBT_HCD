{{ config(
    materialized='table',
    schema='MARTS'
) }}

with appointments as (

    select *
    from {{ ref('int_appointment_enriched') }}

),

patient_metrics as (

    select
        patient_id,
        count(*) as total_appointments,
        count_if(status = 'COMPLETED') as completed_appointments,
        sum(fee_charged) as total_fees_paid,
        max(appointment_date) as last_appointment_date

    from appointments
    group by patient_id

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(['p.patient_id']) }} as patient_sk,
        p.patient_id,
        p.first_name,
        p.last_name,
        p.email,
        p.phone,
        p.patient_city,
        p.gender,
        p.date_of_birth,
        p.plan_id,
        pt.tier,
        pt.plan_name,
        pm.total_appointments,
        pm.completed_appointments,
        pm.total_fees_paid,
        pm.last_appointment_date

    from appointments p

    left join patient_metrics pm
        on p.patient_id = pm.patient_id

    left join {{ ref('plan_tiers') }} pt
        on p.plan_id = pt.plan_id

    qualify row_number() over (
        partition by p.patient_id
        order by p.appointment_updated_at desc
    ) = 1

)

select *
from final