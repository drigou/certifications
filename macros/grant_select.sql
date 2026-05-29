{% macro grant_select(schema=target.schema, role=target.role) %}

    {{ log("Granting select on all tables and views in schema " ~ schema ~ ' to role ' ~ role, info=true)}}

    {% set sql %}

        grant usage on schema {{ schema }} to role {{ role }};
        grant select on all tables in {{ schema }} to role {{ role }};
        grant select on all views in {{ schema }} to role {{ role }};

    {% endset %}

    {% do run_query(sql) %}

    {{ log("Privs granted") }}

{% endmacro %}