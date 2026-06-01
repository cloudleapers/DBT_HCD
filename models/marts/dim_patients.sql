{{config(
    materialized='table'
) }}

select
patient_sk,
patient_id,
first_name,
last_name,
email,
gender,
city,
plan_id,
plan_name,
tier,
tier_rank,
total_appointments,
last_appointment_date
from {{ ref('int_patients') }}