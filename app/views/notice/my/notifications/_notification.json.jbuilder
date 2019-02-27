json.extract! notification,
              :id,
              :notifiable_type,
              :notifiable_id,
              :linked_type,
              :linked_id,
              :title,
              :body,
              :link,
              :created_at,
              :sent_at,
              :official,
              :read_at
json.state notification.state_i18n
json.notifiable notification.notifiable_detail
json.sender notification.sender, :id, :name, :avatar_url
json.linked notification.linked_detail
