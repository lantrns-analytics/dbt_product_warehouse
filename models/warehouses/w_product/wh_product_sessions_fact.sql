{{
    config(
        alias='product_sessions_fact',
        unique_key='product_session_pk'
    )
}}

with sessions as
(

  select * from {{ ref('int_product_sessions') }}

)

select
  {{ dbt_utils.surrogate_key(
    ['session_id']
  ) }} as product_session_pk,
  {{ dbt_utils.surrogate_key(
    ['blended_user_id']
  ) }} as product_user_pk,

  session_start_tstamp as starting_ts,
  session_end_tstamp as ending_ts,
  duration_in_s as duration_s,
  session_number as sequence,
  first_page_url as landing_page,
  last_page_url as exit_page,
  referrer,
  referrer_medium,
  referrer_source

from sessions
