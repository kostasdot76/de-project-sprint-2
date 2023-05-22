--- task 6
-- shipping_datamart 
create or replace view shipping_datamart  as
select 
shipping_id,
vendor_id,
st.transfer_type, -- тип доставки из таблицы shipping_transfer
extract ( day from shipping_end_fact_datetime   - shipping_start_fact_datetime ) as full_day_at_shipping, 
-- — количество полных дней, в течение которых длилась доставка.Высчитывается так: shipping_end_fact_datetime − − shipping_start_fact_datetime
case when shipping_end_fact_datetime >  shipping_plan_datetime then 1 else 0 end as is_delay, 
--статус, показывающий просрочена ли доставка.
case when status  = 'finished' then 1 else 0 end as is_shipping_finish,
--статус, показывающий, что доставка завершена. Если финальный status = finished 
case when shipping_end_fact_datetime >  shipping_plan_datetime then
extract ( day from shipping_end_fact_datetime   - shipping_plan_datetime ) else 0 end as delay_day_at_shipping, 
payment_amount,
 payment_amount * (shipping_country_base_rate + agreement_rate + shipping_transfer_rate) as vat,
 payment_amount * agreement_commission as profit
from shipping_info si 
join shipping_transfer st on si.shipping_transfer_id = st.id 
join shipping_country_rates scr on si.shipping_country_rates_id = scr.id 
join shipping_agreement sa on si.agreement_id = sa.agreement_id 
join shipping_status ss on si.shipping_id = ss.shiping_id; 