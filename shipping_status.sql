-- task 5
-- shipping_status 
-- shipping (status , state).
-- Добавьте туда вычислимую информацию по фактическому времени доставки shipping_start_fact_datetime, shipping_end_fact_datetime 
-- Отразите для каждого уникального shipping_id его итоговое состояние доставки.
-- Данные в таблице должны отражать максимальный status и state по максимальному времени лога state_datetime в таблице shipping.
drop table if exists public.shipping_status;
select shiping_id, state_datetime, status, state, shipping_start_fact_datetime,shipping_end_fact_datetime
into public.shipping_status 
from (
select distinct shippingid as shiping_id,state_datetime, status, state,
min(case when state = 'booked' then state_datetime else null end) over (partition by shippingid) as shipping_start_fact_datetime,
max(case when state = 'recieved' then state_datetime else null  end) over (partition by shippingid) as shipping_end_fact_datetime,
row_number() over (partition by shippingid order by state_datetime desc) as rid
from  shipping s 
order by shippingid, state_datetime 
) ss
where rid = 1;