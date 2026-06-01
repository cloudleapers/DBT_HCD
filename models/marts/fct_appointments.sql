{{ config(
    materialized='table' )}}
select
{{ dbt_utils.generate_surrogate_key(['appointment_id']) }} as appointment_sk,
appointment_id,
appointment_date,
patient_id,
patient_name,
doctor_id,
doctor_name,
specialization,
status,
round(amount_cents/100,2) as payment_amount,
payment_method,
paid_at,updated_at,
{{ generate_audit_columns() }}
from {{ ref('int_appointment_enriched') }}