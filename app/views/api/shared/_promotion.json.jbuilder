json.call(
  promotion,
  :id,
  :title,
  :description,
  :terms,
  :total_rewards,
  :points_required,
  :start_at,
  :end_at,
)

json.office do
  json.partial!(
    "api/shared/office",
    office: promotion.office
  )
end
