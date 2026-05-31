with source as (
    select * from {{ source('raw', 'raw_patients') }}
),
cleaned as (
    select
        patient_id,
        {{ clean_name('first_name') }}       as first_name,
        {{ clean_name('last_name') }}        as last_name,
        lower(trim(email))                   as email,
        {{ try_to_date('date_of_birth') }}   as date_of_birth,
        case
            when upper(left(gender, 1)) = 'M' then 'Male'
            when upper(left(gender, 1)) = 'F' then 'Female'
            else 'Unknown'
        end                                  as gender,
        plan_id,
        {{ generate_audit_columns() }}
    from source
    where email like '%@%.%'           
      and patient_id != 109            
),
deduped as (
    select *,
        row_number() over (partition by email order by patient_id) as rn
    from cleaned
)
select * exclude (rn) from deduped where rn = 1