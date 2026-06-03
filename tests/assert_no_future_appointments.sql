select * from {{ref('stg_appointments')}}
where appointment_date > current_date()