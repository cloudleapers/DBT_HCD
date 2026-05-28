{{ config(materialization='view') }}
with payments as (
    select
        payment_id,
        appointment_id,
        amount_cents,
        payment_method,
        cast(paid_at as date) as paid_date,
        updated_at,
        {{ generate_audit_columns() }}
    from {{ source('raw', 'RAW_PAYMENTS') }}
    where amount_cents >= 0)
select * from payments