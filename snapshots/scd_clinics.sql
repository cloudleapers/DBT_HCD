{% snapshot scd_clinics %}
{{
    config(
      target_database='DBT_HCD',
      target_schema='snapshots',
      unique_key='clinic_id',
      strategy='check',
      check_cols=['city', 'is_operational']
    )
}}

select * from {{ source('raw', 'raw_clinics') }}

{% endsnapshot %}