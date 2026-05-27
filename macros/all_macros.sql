{% macro trim_whitespace(col) %}
    trim(regexp_replace({{ col }}, '\\s+', ' '))
{% endmacro %}

{% macro remove_special_chars(col, mode='name') %}

    {% if mode == 'name' %}
        regexp_replace({{ col }}, '[^A-Za-z /-]', '')
    {% elif mode == 'digits' %}
        regexp_replace({{ col }}, '[^0-9]', '')
    {% endif %}

{% endmacro %}


{% macro clean_name(col) %}

    initcap(
        {{ trim_whitespace(
            remove_special_chars(col,'name')
        ) }}
    )

{% endmacro %}


{% macro initcap_col(col) %}
    initcap({{ col }})
{% endmacro %}

{% macro safe_date(col) %}
    try_to_date({{ col }})
{% endmacro %}

{% macro fee_band(col) %}

case
    when {{ col }} < 100 then 'LOW'
    when {{ col }} between 100 and 500 then 'MEDIUM'
    else 'HIGH'
end

{% endmacro %}

{% macro generate_audit_columns() %}

current_timestamp() as _model_run_at,
'{{ invocation_id }}' as _dbt_run_id

{% endmacro %}
{% macro convert_boolean(column_name) %}

case
    when upper({{ column_name }}) in ('Y','1')
    then TRUE
    else FALSE
end

{% endmacro %}

