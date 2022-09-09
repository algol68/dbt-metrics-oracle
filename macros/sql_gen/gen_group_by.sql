{% macro oracle__gen_group_by(grain,dimensions,calendar_dimensions,relevant_periods) %}

    date_{{ grain }}

    {% for dim in dimensions %}
            ,{{ dim }}
            
    {%- endfor %}
    
    {% for calendar_dim in calendar_dimensions %}
            ,{{ calendar_dim }}            
    {%- endfor %}
        
{% endmacro %}