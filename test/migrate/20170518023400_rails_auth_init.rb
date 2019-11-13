class RailsAuthInit < ActiveRecord::Migration[5.1]
  def change

    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.datetime :last_login_at
      t.string :last_login_ip
      t.boolean :disabled, default: false
      t.string :timezone
      t.string :locale
      t.string :source
      t.timestamps
    end

    create_table :accounts do |t|
      t.references :user
      t.string :type
      t.string :identity
      t.boolean :confirmed, default: false
      t.boolean :primary, default: false
      t.timestamps
    end

    create_table :verify_tokens do |t|
      t.references :user
      t.references :account
      t.string :type
      t.string :token
      t.datetime :expire_at
      t.string :identity
      t.integer :access_counter, default: 0
      t.timestamps
    end
    
    create_table :authorized_tokens do |t|
      t.references :user
      t.references :oauth_user
      t.references :account
      t.string :token, index: { unique: true }
      t.datetime :expire_at
      t.string :session_key
      t.integer :access_counter, default: 0
      t.timestamps
    end

    create_table :oauth_users do |t|
      t.references :user
      t.references :account
      t.string :provider
      t.string :type
      t.string :uid
      t.string :unionid, index: true
      t.string :name
      t.string :avatar_url
      t.string :state
      t.string :access_token
      t.string :refresh_token
      t.string :app_id
      t.datetime :expires_at
      if connection.adapter_name == 'PostgreSQL'
        t.jsonb :extra
      else
        t.json :extra
      end
      t.index [:uid, :provider], unique: true
      t.timestamps
    end
    
    create_table :user_tags do |t|
      t.references :organ  # For SaaS
      t.references :tagging, polymorphic: true
      t.string :name
      t.integer :user_taggeds_count
      t.timestamps
    end
    
    create_table :user_taggeds do |t|
      t.references :user_tag
      t.references :user
      t.timestamps
    end

  end
end

