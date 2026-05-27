{{ config(
    materialized='table' )}}
select
{{ dbt_utils.generate_surrogate_key(['appointment_id']) }} as appointment_sk,
appointment_id,
appointment_date,
patient_id,
concat(first_name,' ',last_name ) as patient_name,
doctor_id,
doctor_name,
specialization,
status,
round(amount_cents/100,2) as payment_amount
from {{ ref('int_appointment_enriched') }}