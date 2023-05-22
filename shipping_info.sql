-- task 4
--shipping_info
drop table if exists public.shipping_info;
CREATE TABLE public.shipping_info (
	shipping_id int8 not NULL,
	shipping_transfer_id int4 not NULL,
	shipping_country_rates_id int4 not NULL,
	agreement_id int4 not NULL,
	vendor_id int8 not NULL,
	shipping_plan_datetime timestamp NULL,
	payment_amount numeric null,
	constraint shipping_info_shipping_transfer_fkey foreign key (shipping_transfer_id) references shipping_transfer(id) on update cascade,
	constraint shipping_info_shipping_country_rates_fkey foreign key (shipping_country_rates_id) references shipping_country_rates(id) on update cascade,
	constraint shipping_info_shipping_agreement_fkey foreign key (agreement_id) references shipping_agreement(agreement_id) on update cascade
);

INSERT INTO public.shipping_info
(shipping_id, shipping_transfer_id, shipping_country_rates_id, agreement_id, vendor_id, shipping_plan_datetime, payment_amount)
select  
s2.shippingid as shipping_id,
st.id  as shipping_transfer_id,
r.id  as shipping_country_rates_id,
sa.agreement_id,
vendorid as vendor_id,
max(shipping_plan_datetime) as shipping_plan_datetime,
max(payment_amount) as payment_amount
from 
shipping s2 
join
	(
		select  id  ,transfer_type || ':' ||  transfer_model as shipping_transfer_description from shipping_transfer 
	) st on s2.shipping_transfer_description = st.shipping_transfer_description
join shipping_country_rates r on s2.shipping_country  = r.shipping_country 
join (
	select agreement_id,
	cast(agreement_id as text)  || ':' ||   
	cast(agreement_number  as text) || ':' ||  
	cast(agreement_rate as text)  || ':' ||
	cast(agreement_commission as text) as vendor_agreement_description
	from public.shipping_agreement
) sa on s2.vendor_agreement_description = sa.vendor_agreement_description
group by 
s2.shippingid,
st.id,
r.id,
sa.agreement_id,
vendorid;