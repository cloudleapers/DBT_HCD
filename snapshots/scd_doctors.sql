{% snapshot scd_doctors %}

{{
    config(
        target_schema='snapshots',
        unique_key='doctor_id',
        strategy='check',
        check_cols=['consultation_fee','is_available','clinic_id']
    )
}}

select * from {{ source('inter', 'STG_DOCTORS') }}

{% endsnapshot %}