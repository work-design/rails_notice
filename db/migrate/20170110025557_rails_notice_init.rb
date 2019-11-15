class RailsNoticeInit < ActiveRecord::Migration[5.0]
  def change

    create_table :notifications do |t|
      t.references :organ  # For SaaS
      t.references :receiver, polymorphic: true
      t.references :sender, polymorphic: true
      t.references :notifiable, polymorphic: true
      t.references :linked, polymorphic: true
      t.string :code
      t.string :state
      t.string :title
      t.string :body, limit: 5000
      t.string :link
      t.datetime :sending_at
      t.datetime :read_at, index: true
      t.boolean :verbose, default: false
      t.boolean :official, default: false
      t.boolean :archived, default: false
      t.datetime :created_at, null: false, index: true
      t.datetime :updated_at, null: false
    end
    
    create_table :notification_sendings do |t|
      t.string :way
      t.string :sent_to
      t.datetime :sent_at
      t.string :sent_result
      t.timestamps
    end

    create_table :notification_settings do |t|
      t.references :receiver, polymorphic: true
      t.integer :showtime
      t.boolean :accept_email, default: true
      if connection.adapter_name == 'PostgreSQL'
        t.string :notifiable_types, array: true
        t.jsonb :counters, default: {}
      else
        t.string :notifiable_types
        t.json :counters, default: {}
      end
      t.timestamps
    end

    create_table :notify_settings do |t|
      t.string :notifiable_type
      t.string :code
      t.string :notify_mailer
      t.string :notify_method
      t.string :only_verbose_columns
      t.string :except_verbose_columns
      t.string :cc_emails
      t.timestamps
    end

    create_table :annunciations do |t|
      t.references :organ  # For SaaS
      t.references :publisher, polymorphic: true
      t.string :title
      t.string :body
      t.string :link
      t.integer :notifications_count
      t.timestamps
    end
    
    create_table :annunciates do |t|
      t.references :annunciation
      t.references :user_tag
      t.string :receiver_type
      t.string :state
      t.datetime :annunciated_at
      t.timestamps
    end

  end
end
