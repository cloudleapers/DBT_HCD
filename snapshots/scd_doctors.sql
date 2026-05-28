{% snapshot scd_doctors %}
{{
    config(
      target_database='DBT_HCD',
      target_schema='snapshots',
      unique_key='doctor_id',
      strategy='check',
      check_cols=['consultation_fee','is_available']
    )
}}

select * from {{ source('raw', 'raw_doctors') }}

{% endsnapshot %}