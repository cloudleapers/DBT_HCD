with patient_summary as (

    select
        {{ dbt_utils.generate_surrogate_key(['sp.patient_id']) }} as patient_sk,
        sp.patient_id,
        sp.first_name,
        sp.last_name,
        sp.email,
        sp.gender,
        sum(pt.appointment_fee) as total_spend,
        count(*) as total_appointments

    from {{ ref('stg_patients') }} sp
    inner join {{ ref('stg_appointments') }} pt
        on sp.patient_id = pt.patient_id

    group by
        sp.patient_id,
        sp.first_name,
        sp.last_name,
        sp.email,
        sp.gender

)

select * from patient_summary