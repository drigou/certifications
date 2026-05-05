with payments as (
    select * from {{ ref('stg_stripe__payments') }}
),

orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
),

final as (
    select 
        orders.order_id,
        orders.customer_id,
        sum(payments.amount) as amount
    from payments 
    inner join orders
        on payments.order_id = orders.order_id
    group by
        orders.order_id,
        orders.customer_id
)

select * from final