-- task3
drop table if exists public.shipping_transfer; 
create table public.shipping_transfer (
	id serial4 NOT NULL,
	transfer_type text NULL,
	transfer_model text NULL,	
	shipping_transfer_rate numeric(14, 3) NULL,	
	CONSTRAINT shipping_transfer_pkey PRIMARY KEY (id)
);

INSERT INTO public.shipping_transfer
(transfer_type, transfer_model, shipping_transfer_rate)
select distinct 
s[1],
s[2],
shipping_transfer_rate
from (
select regexp_split_to_array(shipping_transfer_description , ':+') as s, shipping_transfer_rate
from shipping s
) a
order by s[1];