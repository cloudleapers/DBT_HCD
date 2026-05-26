{% macro trim_whitespace(col) %}
    regexp_replace(trim({{ col }}), '\\s+', ' ')
{% endmacro %}

{% macro remove_special_chars(col, mode='name') %}
    {% if mode == 'name' %}
        regexp_replace({{ col }}, '[^a-zA-Z \\''-]', '')
    {% elif mode == 'digits' %}
        regexp_replace({{ col }}, '[^0-9]', '')
    {% else %}
        {{ col }}
    {% endif %}
{% endmacro %}

{% macro clean_name(col) %}
    initcap(
        {{ trim_whitespace(
            remove_special_chars(col, mode='name')
        ) }}
    )
{% endmacro %}

{% macro initcap_safe(col) %}
    initcap({{ col }})
{% endmacro %}

{% macro try_to_date(col) %}
    coalesce(
        try_to_date({{ col }}, 'YYYY-MM-DD'),   
        try_to_date({{ col }}, 'YYYY/MM/DD'),   
        try_to_date({{ col }}, 'DD-MM-YYYY'),   
        try_to_date({{ col }}, 'DD/MM/YYYY'),   
        NULL
    )                                     
{% endmacro %}

{% macro fee_band(col) %}
   
    case
        when {{ col }} < 0                    then 'Invalid'   
        when {{ col }} >= 0    and {{ col }} < 600  then 'Low'
        when {{ col }} >= 600  and {{ col }} < 1000 then 'Medium'
        when {{ col }} >= 1000                then 'High'
        else 'Unknown'
    end
{% endmacro %}

{% macro generate_audit_columns() %}
    current_timestamp()                          as _model_run_at,
    '{{ invocation_id }}'                        as _dbt_run_id
{% endmacro %}