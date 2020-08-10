with events as (

    select * from {{ ref('stg_product_tracks') }}

),

sessions as (

  select * from {{ ref('stg_product_sessions') }}

),

joined as (

 select
   events.track_id as event_id,
   sessions.session_id,

   events.user_id,
   events.anonymous_id,
   events.blended_user_id,

   events.context_ip,
   events.context_user_agent,
   events.context_page_path,

   events.event_name,

   events.event_ts

 from events
 left join sessions
  on events.blended_user_id = sessions.blended_user_id
  and events.ts between sessions.session_start_tstamp and sessions.session_end_tstamp

),

dedup as (

  select *,
    row_number() over (partition by event_id
      order by session_start_tstamp) as row_rank

  from joined

)

select * from dedup where row_rank = 1
