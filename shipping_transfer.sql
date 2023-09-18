drop table if exists public.shipping_transfer;
create table public.shipping_transfer(
	id 		  				serial primary key,
	transfer_type	 		text,
	transfer_model	        text,
	shipping_transfer_rate  numeric(14,3)
);

create index shipping_transfer_id on public.shipping_transfer (id);

insert into public.shipping_transfer (transfer_type,transfer_model,shipping_transfer_rate )
select distinct 
		st.shipping_transfer[1]::text,
		st.shipping_transfer[2]::text,
		st.shipping_transfer_rate::numeric(14,3)	
from(
		select distinct 
				regexp_split_to_array(shipping_transfer_description, ':+') as shipping_transfer,
				shipping_transfer_rate
		from public.shipping
	 ) as st;
	

