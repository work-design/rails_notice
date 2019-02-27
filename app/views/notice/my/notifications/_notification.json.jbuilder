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
              :read_at,
              :notifiable_detail
json.state notification.state_i18n
json.sender notification.sender, :id, :name, :avatar_url
json.linked notification.linked, :cover_url
