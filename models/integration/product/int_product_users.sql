with product_pages as (

	select * from {{ ref('stg_product_pages') }}

),

final as (

	select distinct
		blended_user_id

	from product_pages

)

select * from final
