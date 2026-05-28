select * from {{ source('raw', 'raw_clinics') }}
where lower(clinic_name) != 'test'