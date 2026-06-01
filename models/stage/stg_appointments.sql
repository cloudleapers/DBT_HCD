WITH appointment AS (

    SELECT
        a.appointment_id,
        a.patient_id,
        a.doctor_id,
        a.clinic_id,
        {{ try_to_date('a.appointment_date') }} AS appointment_date,
        UPPER(TRIM(a.status)) AS st_status

    FROM {{ source('raw', 'APPOINTMENTS') }} a

    INNER JOIN {{ ref('stg_patients') }} p
        ON p.patient_id = a.patient_id

    INNER JOIN {{ ref('stg_doctors') }} d
        ON d.doctor_id = a.doctor_id

    WHERE a.appointment_id IS NOT NULL
      AND a.appointment_date IS NOT NULL
      AND a.patient_id IS NOT NULL
      AND a.doctor_id IS NOT NULL

)

SELECT
    appointment_id,
    patient_id,
    doctor_id,
    clinic_id,
    appointment_date,
    st_status,
    {{ generate_audit_columns() }}
FROM appointment