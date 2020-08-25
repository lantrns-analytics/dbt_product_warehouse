{{
    config(
        alias='product_users_dim',
        unique_key='product_user_pk'
    )
}}

with users as (

  select * from {{ ref('int_product_users') }}

),

sessions as (

  select
    product_user_fk,

    last_value(device) over (partition by product_user_fk order by ending_ts) as latest_device,
    last_value(device_category) over (partition by product_user_fk order by ending_ts) as latest_device_category,

    starting_ts,
    ending_ts,
    sequence,
    duration_s

  from {{ ref('wh_product_sessions_fact') }}

),

session_aggs as (

  select
    product_user_fk,
    latest_device,
    latest_device_category,

    min(starting_ts) as first_seen_ts,
    max(ending_ts) as last_seen_ts,
    max(sequence) as total_sessions,
    sum(duration_s) as usage_time_s

  from sessions

  group by 1, 2, 3

),

events as (

  select
    product_user_fk,

    count(product_event_pk) as total_events

  from {{ ref('wh_product_events_fact') }}

  group by 1

),

base_users as (

  select
    {{ dbt_utils.surrogate_key(
      ['blended_user_id']
    ) }} as product_user_pk,

    blended_user_id as segment_blended_user_id

  from users

),

final as (

  select
    base_users.*,
    session_aggs.latest_device,
    session_aggs.latest_device_category,
    session_aggs.first_seen_ts,
    session_aggs.last_seen_ts,
    session_aggs.total_sessions,
    session_aggs.usage_time_s,
    events.total_events

  from base_users
  left join session_aggs on base_users.product_user_pk = session_aggs.product_user_fk
  left join events on base_users.product_user_pk = events.product_user_fk
)

select * from final
