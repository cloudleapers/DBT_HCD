select * from {{source('stg', 'stg_appointments')}}
where appointment_date > current_date()