drop table if exists public.shipping_status;
create table public.shipping_status(
	shipping_id 		   		 bigint primary key,
	status				   		 text,
	state		 	      		 text,
	shipping_start_fact_datetime timestamp,
	shipping_end_fact_datetime	 timestamp
);


insert into public.shipping_status (shipping_id,status,state,shipping_start_fact_datetime,shipping_end_fact_datetime)

with start_time as(
					select
						shippingid     as shippingid,
						state_datetime as st_time
					from public.shipping
					where state = 'booked'
				  ),
     end_time as(
					select
						shippingid     as shippingid,
						state_datetime as et_time
					from public.shipping
					where state = 'recieved'
				),
	  maximum as(
					select 
						shippingid  as shippingid,
						max(state_datetime) as m_date
					from public.shipping 
					group by shippingid
				)
select
	s.shippingid,
	s.status,
	s.state,
	st.st_time,
	et.et_time
from public.shipping as s
left join start_time as st 
	   on st.shippingid = s.shippingid 	
left join end_time as et 
	   on et.shippingid = s.shippingid
right join maximum as m
		on m.shippingid     = s.shippingid and 
		   m.m_date = s.state_datetime
order by shippingid;
