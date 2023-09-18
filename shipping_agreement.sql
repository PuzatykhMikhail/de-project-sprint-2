drop table if exists public.shipping_agreement;
create table public.shipping_agreement(
	agreement_id 		  int8 primary key,
	agreement_number	  text,
	agreement_rate 	      numeric(14,3),
	agreement_commission  numeric(14,3)
);


insert into public.shipping_agreement (agreement_id,agreement_number,agreement_rate,agreement_commission )
select distinct 
		sa.shipping_agreement[1]::int8,
		sa.shipping_agreement[2]::text,
		sa.shipping_agreement[3]::numeric(14,3),
		sa.shipping_agreement[4]::numeric(14,3)		
from(
		select distinct 
				regexp_split_to_array(vendor_agreement_description, ':+') as shipping_agreement
		from public.shipping
	 ) as sa;
