{% macro clean_stale_models(database=target.database, schema=target.schema, days=7, dry_run=True) %}

    {% set query %}

        select 
            table_type,
            table_catalog,
            table_schema,
            table_name,
            last_altered,
            case when table_type = 'VIEW' then table_type else 'TABLE' end as drop_type,
            'DROP ' || drop_type || ' {{database | upper }}.' || table_schema || '.' || table_name || ';' as drop_query
        from {{ database }}.information_schema.tables
        where table_schema = upper('{{ schema }}')
            and date(last_altered) >= date(current_date - {{ days }}) 
        order by 4 desc

    {% endset %}

    {{ log('\nGenerating cleanup queries ... \n') }}
    {% set drop_queries=run_query(query).to_columns[1].values() %}
    {% for drop_query in drop_queries %}

        {% if dry_run %}
            {{ log(drop_query, info=true) }}

        {% else %}

            {{ log('Dropping object with command ' ~ drop_query, info=true) }}
            {% do run_query(drop_query) %}
            
        {% endif %}
        
    {% endfor %}

{% endmacro %}