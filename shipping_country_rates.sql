drop table if exists public.shipping_info  cascade;
-- task 1
drop table if exists public.shipping_country_rates; 
create table public.shipping_country_rates (
	id serial4 NOT NULL,
	shipping_country text NULL,
	shipping_country_base_rate numeric(14, 3) NULL,
	CONSTRAINT shipping_country_rates_pkey PRIMARY KEY (id)
);
INSERT INTO public.shipping_country_rates
(shipping_country, shipping_country_base_rate)
select distinct shipping_country, shipping_country_base_rate from shipping s;