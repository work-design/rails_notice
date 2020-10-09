json.extract!(
  notification,
  :id,
  :notifiable_type,
  :notifiable_id,
  :linked_type,
  :linked_id,
  :title,
  :body,
  :link,
  :created_at,
  :official,
  :read_at
)
json.state notification.state_i18n
json.notifiable notification.notifiable_detail
if notification.sender
  json.sender notification.sender, :id, :name, :avatar_url
end
json.linked notification.linked_detail
