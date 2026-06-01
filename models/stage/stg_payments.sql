select * from {{ ref('payments') }}
where appointment_id != 8888
  and amount_cents >= 0