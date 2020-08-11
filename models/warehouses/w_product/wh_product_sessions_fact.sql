{{
    config(
      alias='product_sessions_fact',
      unique_key='product_session_pk',
      incremental_strategy='merge',
      materialized='incremental'
    )
}}

with sessions as
(

  select * from {{ ref('int_product_sessions') }}

),

final as (

  select
    {{ dbt_utils.surrogate_key(
      ['session_id']
    ) }} as product_session_pk,
    {{ dbt_utils.surrogate_key(
      ['blended_user_id']
    ) }} as product_user_fk,

    session_start_tstamp as starting_ts,
    session_end_tstamp as ending_ts,
    duration_in_s as duration_s,
    session_number as sequence

  from sessions

)

select * from final

{% if is_incremental() %}
  where starting_ts > (select max(starting_ts) from {{ this }})
{% endif %}
