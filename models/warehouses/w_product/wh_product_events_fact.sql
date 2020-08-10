{{
    config(
        alias='product_events_fact',
        unique_key='product_event_pk'
    )
}}

with events as
(

  select * from {{ ref('int_product_events') }}

)

select
  {{ dbt_utils.surrogate_key(
    ['event_id']
  ) }} as product_event_pk,
  {{ dbt_utils.surrogate_key(
    ['session_id']
  ) }} as product_session_fk,
  {{ dbt_utils.surrogate_key(
    ['blended_user_id']
  ) }} as product_user_fk,
  event_id as segment_event_id,

  event_ts
  event_name,
  context_page_path as event_url

from events
