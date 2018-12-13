json.extract! notification,
              :id,
              :notifiable_type,
              :notifiable_id,
              :title,
              :body,
              :link,
              :created_at,
              :sent_at,
              :read_at

json.state notification.state_i18n
json.sender notification.sender, :id, :name, :avatar_url
