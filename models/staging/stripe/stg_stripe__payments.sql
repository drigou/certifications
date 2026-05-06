select 
    id as payment_id,
    orderid as order_id,
    paymentmethod,
    status as order_status,
    amount,
    created
from {{ source('stripe', 'payment') }}