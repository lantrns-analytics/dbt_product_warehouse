with source as (

	select * from {{ source('segment', 'tracks') }}

),

final as (

	select
		cast(id as string) as track_id,

		cast(user_id as string) as user_id,
		cast(anonymous_id as string) as anonymous_id,
		cast(coalesce(user_id, anonymous_id) as string) as blended_user_id,

		cast(context_ip as string) as context_ip,
		cast(context_user_agent as string) as context_user_agent,
		cast(context_page_path as string) as context_page_path,

		cast(event_text AS string) AS event_name,

		cast(timestamp AS datetime) AS track_ts

	from source

)

select * from final
