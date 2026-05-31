select * from {{ ref('fct_appointments') }}
where status = 'COMPLETED'
  and appointment_date > current_date()