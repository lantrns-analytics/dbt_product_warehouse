with source as (

	select * from {{ ref(var('sessions-base-model')) }}

),

final as (

  select
    session_id,
    session_number,
    anonymous_id,
    blended_user_id,

    session_start_tstamp,
    session_end_tstamp,
    duration_in_s,
    duration_in_s_tier,

    page_views,
    first_page_url,
    last_page_url,

    referrer,
    referrer_medium,
    referrer_source,

    device,
    device_category

  from source

)

select * from final
