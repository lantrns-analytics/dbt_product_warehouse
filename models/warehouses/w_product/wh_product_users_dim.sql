{{
    config(
        alias='product_users_dim',
        unique_key='product_user_pk'
    )
}}

with users as
(

  select * from {{ ref('int_product_users') }}

),

final as (

  select
    {{ dbt_utils.surrogate_key(
      ['blended_user_id']
    ) }} as platform_user_pk,
    blended_user_id as segment_blended_user_id,

    user_ts, 
    name,
    email

  from users

)

select * from final
