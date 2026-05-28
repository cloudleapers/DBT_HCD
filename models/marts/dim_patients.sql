{{ config(materialized='table') }}
select
patient_id,
total_appointments,
total_fees,
avg_fee,
patient_sk,
email,
phone,
city,
gender,
tier,
updated_at
from {{ ref('int_dim_patients') }}