create or replace view public.shipping_datamart as
select 
	si.shipping_id      																																	    	as shipping_id,
	si.vendor_id         																																		    as vendor_id,
	st.transfer_type  																																     			as tranfer_type,
	date_part('day', ss.shipping_end_fact_datetime - ss.shipping_start_fact_datetime ) 				   																as full_day_at_shipping,	
	case 
		when  ss.shipping_end_fact_datetime > si.shipping_plan_datetime then 1
		else 0
	end 																																						     as is_delay,
    case
	 	when ss.status = 'finished' then 1
	 	else 0
	end  																																							 as is_shipping_finish,
	case 
		when  ss.shipping_end_fact_datetime > si.shipping_plan_datetime then date_part('day', ss.shipping_end_fact_datetime - si.shipping_plan_datetime)
		else 0
	 end 					   																																		  as delay_day_at_shipping,
	 si.payment_amount 																																			      as payment_amount,
	 si.payment_amount::numeric(14,3) * (scr.shipping_country_base_rate::numeric(14,3) + sa.agreement_rate::numeric(14,3) + st.shipping_transfer_rate::numeric(14,3)) as vat,
	 si.payment_amount::numeric(14,3) * sa.agreement_commission::numeric(14,3) 																						  as profit
from public.shipping_info si
left join public.shipping_country_rates scr
	   on scr.id  = si.shipping_country_id  
left join public.shipping_agreement sa
	   on sa.agreement_id = si.agreement_id 
left join public.shipping_transfer st 
	   on st.id = si.transfer_type_id 
left join public.shipping_status ss 
	   on ss.shipping_id = si.shipping_id ;
