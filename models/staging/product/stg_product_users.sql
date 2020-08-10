with source as (

	select * from {{ var('cdp-users-table') }}

),

final as (

	select
		cast(id as string) as blended_user_id,

		cast(name as string) as name,
		cast(email as string) as email,

		cast(received_at as datetime) as user_ts

	from source

)

select * from final
