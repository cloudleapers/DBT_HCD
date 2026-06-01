{% snapshot scd_clinics %}

{{
    config(
        target_schema='snapshots',
        unique_key='clinic_id',
        strategy='check',
        check_cols='all'
    )
}}
select * from {{ ref('stg_clinics') }}
{% endsnapshot %}