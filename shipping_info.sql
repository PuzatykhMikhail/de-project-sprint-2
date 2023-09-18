drop table if exists public.shipping_info;
create table public.shipping_info(
	shipping_id 		   bigint primary key,
	shipping_plan_datetime timestamp,
	payment_amount 	       numeric(14,3),
	vendor_id              bigint,
	shipping_country_id	   int8,
	agreement_id		   int8,
	transfer_type_id	   int8,
	foreign key (shipping_country_id) references public.shipping_country_rates(id) on update cascade,
	foreign key (agreement_id) references public.shipping_agreement(agreement_id) on update cascade,
	foreign key (transfer_type_id) references public.shipping_transfer(id) on update cascade
);


insert into public.shipping_info (shipping_id,shipping_plan_datetime,payment_amount,vendor_id,shipping_country_id, agreement_id,transfer_type_id  )

with agr_id_ship as (
		select 
			ais.shipping_agreement[1]::int as agreementid,
			ais.shippingid
		from(
				select distinct 
					regexp_split_to_array(vendor_agreement_description, ':+') as shipping_agreement,
					shippingid
				from public.shipping 
			)ais		
) 

select distinct 
	s.shippingid, 		   
	s.shipping_plan_datetime, 
	s.payment_amount, 	       
	s.vendorid ,              
	scr.id,   
	sa.agreementid,		  
	st.id	   
from public.shipping  as s
left join public.shipping_country_rates scr 
		on  scr.shipping_country = s.shipping_country 
left join agr_id_ship sa 
		on sa.shippingid = s.shippingid 
left join public.shipping_transfer st 
		on (st.transfer_type  ||':'|| st.transfer_model) = s.shipping_transfer_description ;
		