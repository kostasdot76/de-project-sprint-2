-- task2
drop table if exists public.shipping_agreement;
create table public.shipping_agreement (
	agreement_id integer NOT NULL,
	agreement_number text,
	agreement_rate  numeric(14, 2) NULL,
	agreement_commission  numeric(14, 2) NULL,
	CONSTRAINT shipping_agreement_pkey PRIMARY KEY (agreement_id)
);

INSERT INTO public.shipping_agreement
(agreement_id, agreement_number, agreement_rate, agreement_commission)
select distinct 
cast(s[1] as integer),
s[2],
cast(s[3] as numeric(14, 2)),
cast(s[4] as numeric(14, 2))
from (
select regexp_split_to_array(vendor_agreement_description, ':+') as s
from shipping s
) a
order by cast(s[1] as integer);