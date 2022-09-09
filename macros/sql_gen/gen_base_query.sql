{% macro oracle__gen_base_query(metric_name, metric_type, metric_sql, metric_timestamp, metric_filters, model, grain, dimensions, secondary_calculations, start_date, end_date, calendar_tbl, relevant_periods, calendar_dimensions) %}

    {# This is the "base" CTE which selects the fields we need to correctly 
    calculate the metric.  #}
    select 
        {# This section looks at the sql aspect of the metric and ensures that 
        the value input into the macro is accurate #}
        {{ dbt_metrics_oracle.cast_string_to_date('\'' ~ metric_timestamp ~ '\'') }} as metric_date_day, -- timestamp field
        calendar_table.date_{{ grain }} as date_{{grain}},
        {% if secondary_calculations | length > 0 %}
            {% for period in relevant_periods %}
                calendar_table.date_{{ period }},
            {% endfor %}
        {% endif %}
        -- ALL DIMENSIONS
        {% for dim in dimensions %}
            {{ dim }},
        {%- endfor %}
        {% for calendar_dim in calendar_dimensions %}
            {{ calendar_dim }},
        {%- endfor %}
        {%- if metric_sql and metric_sql | replace('*', '') | trim != '' -%}
            {{ metric_sql }} as property_to_aggregate
        {%- elif metric_type == 'count' -%}
            1 as property_to_aggregate /*a specific expression to aggregate wasn't provided, so this effectively creates count(*) */
        {%- else -%}
            {%- do exceptions.raise_compiler_error("Expression to aggregate is required for non-count aggregation in metric `" ~ metric.name ~ "`") -%}  
        {%- endif %}
    from {{ model }}
    left join {{calendar_tbl}} calendar_table
        on {{ dbt_utils.date_trunc('day', metric_timestamp) }} = date_day
    where 1=1
    
    -- metric start/end dates also applied here to limit incoming data
    {% if start_date or end_date%}
        and (
        {% if start_date and end_date %}
            {{ dbt_utils.date_trunc('day', metric_timestamp) }} >= {{ dbt_metrics_oracle.cast_string_to_date('\'' ~ start_date ~ '\'') }}
            and {{ dbt_utils.date_trunc('day', metric_timestamp) }} <= {{ dbt_metrics_oracle.cast_string_to_date('\'' ~ end_date ~ '\'') }}
        {% elif start_date and not end_date %}
            {{ dbt_utils.date_trunc('day', metric_timestamp) }} >= {{ dbt_metrics_oracle.cast_string_to_date('\'' ~ start_date ~ '\'') }}
        {% elif end_date and not start_date %}
            {{ dbt_utils.date_trunc('day', metric_timestamp) }} <= {{ dbt_metrics_oracle.cast_string_to_date('\'' ~ end_date ~ '\'') }}
        {% endif %} 
        )
    {% endif %} 

    -- metric filter clauses...
    {% if metric_filters %}
    and (
        {%- for filter in metric_filters %}
            {{ filter.field }} {{ filter.operator }} {{ filter.value }}
            {% if not loop.last %} and {% endif %}
        {%- endfor %}
    )
    {% endif%}

{% endmacro %}
