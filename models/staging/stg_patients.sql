{{ config(schema='STAGING') }}

with patients_cleaned as (

    select
        p.patient_id,
        p.plan_id,
        {{ clean_name('p.first_name') }} as first_name,
        {{ clean_name('p.last_name') }} as last_name,
        lower(trim(p.email)) as email,
        {{ remove_special_chars('p.phone', 'digits') }} as phone,
        city,
        {{ try_to_date('p.date_of_birth') }} as date_of_birth,
        case
            when lower(p.gender) in ('m', 'male') then 'Male'
            when lower(p.gender) in ('f', 'female') then 'Female'
            else 'Unknown'
        end as gender,
        p.updated_at
    from {{ source('raw', 'RAW_PATIENTS') }} p
    inner join {{source('raw', 'RAW_INSURANCE_PLANS')}} ip
        on p.plan_id = ip.plan_id
    where {{ lower_trim('p.email') }} not like '%@@%'
      and {{ lower_trim('p.email') }} not like '%test%'
      and p.email is not null

),

deduplicated as (

    select *
    from patients_cleaned
    qualify row_number() over (
        partition by email
        order by updated_at desc
    ) = 1

)

select * from deduplicated order by patient_id asc