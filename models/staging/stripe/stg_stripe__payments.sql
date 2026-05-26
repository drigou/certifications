select 
    id as payment_id,
    orderid as order_id,
    paymentmethod,
    status as order_status,
    {{ cents_to_dollars("amount", 2) }} as amount,
    created
from {{ source('stripe', 'payment') }}