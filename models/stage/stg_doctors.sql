WITH doc AS (
    SELECT
        doctor_id,
        {{ clean_name('doctor_name') }} AS doctor_name,
        clinic_id,
        ROUND(CAST(consultation_fee AS NUMBER(10,2)), 2) AS consultation_fee,
        {{ fee_band('consultation_fee') }} AS fee_band,
        TRIM(specialization) AS specialization

    FROM {{ source('raw', 'DOCTORS') }}

    WHERE doctor_id IS NOT NULL
      AND consultation_fee > 0
)

SELECT * FROM doc