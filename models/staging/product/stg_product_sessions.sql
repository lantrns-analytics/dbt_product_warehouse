with source as (

	select * from {{ ref(var('sessions-base-model')) }}

),

final as (

  select
    session_id,
    session_number,
    blended_user_id,

    session_start_tstamp,
    session_end_tstamp,
    duration_in_s,
    duration_in_s_tier

  from source

)

select * from final
