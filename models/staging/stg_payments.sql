select * from {{ source('raw', 'raw_payments') }}
where appointment_id != 8888
  and amount_cents >= 0