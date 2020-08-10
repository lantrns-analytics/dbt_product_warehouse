with final as (

	select * from {{ ref('stg_product_users') }}

)

select * from final
