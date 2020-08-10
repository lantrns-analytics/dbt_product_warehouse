with final as (

	select * from {{ ref('stg_product_sessions') }}

)

select * from final
