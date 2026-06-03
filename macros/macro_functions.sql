{% macro trim_whitespace(col) %}
    regexp_replace(
        trim({{ col }}),
        '\\s+',
        ' '
    )
{% endmacro %}

{% macro remove_special_chars(col, mode='name') %}

    {% if mode == 'name' %}

        regexp_replace(
            {{ col }},
            '[^A-Za-z''\\- ]',
            ''
        )

    {% elif mode == 'digits' %}

        regexp_replace(
            {{ col }},
            '[^0-9]',
            ''
        )

    {% endif %}

{% endmacro %}

{% macro clean_name(col) %}

    {{ initcap(
        trim_whitespace(
            remove_special_chars(col)
        )
    ) }}

{% endmacro %}

{% macro initcap(col) %}

    initcap({{ col }})

{% endmacro %}

{% macro try_to_date(col) %}

    try_to_date({{ col }})

{% endmacro %}

{% macro fee_band(col) %}

    case
        when {{ col }} < 100 then 'Low'
        when {{ col }} < 1000 then 'Medium'
        else 'High'
    end

{% endmacro %}

{% macro generate_audit_columns() %}

    current_timestamp() as _model_run_at,
    '{{ run_started_at }}' as _dbt_run_started_at,
    '{{ invocation_id }}' as _dbt_run_id

{% endmacro %}

{% macro neg_to_pos(col) %}

    case 
        when {{ col }} < 0 then abs({{ col }})
        else {{ col }} 

{% endmacro %}

{% macro upper_col(col) %}

    upper({{ col }})

{% endmacro %}

{% macro generate_schema_name(custom_schema_name, node) %}

    {% if custom_schema_name is none %}
        {{ target.schema }}
    {% else %}
        {{ custom_schema_name }}
    {% endif %}

{% endmacro %}

{% macro lower_trim(column_name) %}
    upper(trim({{ column_name }}))
{% endmacro %}