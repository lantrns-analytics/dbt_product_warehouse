with pages as (

	select blended_user_id from {{ ref('stg_product_pages') }}

),

tracks as (

	select blended_user_id from {{ ref('stg_product_tracks') }}

),

final as (

	select blended_user_id from pages
	union all
	select blended_user_id from tracks

)

select distinct blended_user_id from final
