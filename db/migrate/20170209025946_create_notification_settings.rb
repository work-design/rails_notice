class CreateNotificationSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :notification_settings do |t|
      t.references :receiver, polymorphic: true, index: true
      t.string :notifiable_types
      t.integer :showtime
      t.boolean :accept_email, default: true
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

  end
end
