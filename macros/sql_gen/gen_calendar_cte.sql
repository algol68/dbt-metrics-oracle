{% macro oracle__gen_calendar_cte(calendar_tbl,start_date,end_date) %}

with calendar as (

    {# This CTE creates our base calendar and then limits the date range for the 
    start and end date provided by the macro call #}
    select * 
    from {{ calendar_tbl }}
    {% if start_date or end_date%}
        {% if start_date and end_date %}
            where date_day >= {{ dbt_metrics_oracle.cast_string_to_date('\'' ~ start_date ~ '\'') }}
            and date_day <= {{ dbt_metrics_oracle.cast_string_to_date('\'' ~ end_date ~ '\'') }}
        {% elif start_date and not end_date %}
            where date_day >= {{ dbt_metrics_oracle.cast_string_to_date('\'' ~ start_date ~ '\'') }}
        {% elif end_date and not start_date %}
            where date_day <= {{ dbt_metrics_oracle.cast_string_to_date('\'' ~ end_date ~ '\'') }}
        {% endif %}       
    {% endif %} 

)

{% endmacro %}
