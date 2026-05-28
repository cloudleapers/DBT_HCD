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


{% macro gender(column_name) %}

    case
        when lower({{ column_name }}) in ('m', 'male') then 'Male'
        when lower({{ column_name }}) in ('f', 'female') then 'Female'
        else 'Unknown'
    end

{% endmacro %}


{% macro available(column_name) %}
    case 
        when lower({{ column_name }}) in ('y', '1') then true
        when lower({{ column_name }}) in ('n', '0') then false
        else null
    end
{% endmacro %}