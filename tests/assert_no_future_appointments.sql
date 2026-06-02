select * from {{ ref('fct_appointments') }}
where upper(status) = 'COMPLETED' 
and appointment_date > current_date