{% macro trim_whitespace(col) %}
    trim(regexp_replace({{ col }}, '\\s+', ' '))
{% endmacro %}

{% macro remove_special_chars(col, mode='name') %}
    {% if mode == 'name' %}
        regexp_replace({{ col }},'[^A-Za-z ''-]','')
    {% elif mode == 'digits' %}
        regexp_replace({{ col }},'[^0-9]','')
    {% endif %}
{% endmacro %}

{% macro initcap(col) %}
    initcap({{ col }})
{% endmacro %}

{% macro clean_name(col) %}
    {{ initcap(trim_whitespace(remove_special_chars(col, 'name'))) }}
{% endmacro %}

{% macro try_to_date(col) %}
    try_to_date({{ col }})
{% endmacro %}

{% macro fee_band(col) %}
case
    when {{ col }} < 100 then 'Low'
    when {{ col }} <= 500 then 'Medium'
    else 'High'
end
{% endmacro %}

{% macro generate_audit_columns() %}
    current_timestamp as _model_run_at,
    '{{ invocation_id }}' as _dbt_run_id
{% endmacro %}