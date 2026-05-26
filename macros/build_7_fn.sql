{% macro trim_whitespace(col) %}
    regexp_replace(trim({{ col }}), '\\s+', ' ')
{% endmacro %}


{% macro remove_special_chars(col, mode='name') %}
    {% if mode == 'name' %}
        regexp_replace({{ col }}, $$[^a-zA-Z\s'\-]$$, '')
    {% elif mode == 'digits' %}
        regexp_replace({{ col }}, '[^0-9]', '')
    {% else %}
        {{ col }}
    {% endif %}
{% endmacro %}



{% macro initcap(col) %}
    {% if target.type == 'snowflake' %}
        initcap({{ col }})
    {% else %}
        upper(left({{ col }}, 1)) || lower(substr({{ col }}, 2))
    {% endif %}
{% endmacro %}

{% macro clean_name(col) %}
    initcap({{ trim_whitespace(remove_special_chars(col, mode='name')) }})
{% endmacro %}


{% macro try_to_date(col) %}
    {% if target.type == 'snowflake' %}
        try_to_date({{ col }})
    {% else %}
        case
            when {{ col }} is null then null
            when {{ col }} not like '____-__-__' then null
            else cast({{ col }} as date)
        end
    {% endif %}
{% endmacro %}


{% macro fee_band(col) %}
    case
        when {{ col }} < 500  then 'Low'
        when {{ col }} < 1500 then 'Medium'
        else                       'High'
    end
{% endmacro %}


{% macro generate_audit_columns() %}
    current_timestamp()   as _model_run_at,
    '{{ invocation_id }}' as _dbt_run_id
{% endmacro %}