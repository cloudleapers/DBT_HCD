select * from {{ source('raw', 'RAW_PAYMENTS') }}
where amount_cents >= 0
