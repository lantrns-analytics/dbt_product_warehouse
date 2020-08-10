with final as (

	select * from {{ ref('stg_product_sessions-base-model') }}

),

select * from final
