class CreateNotificationSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :notification_settings do |t|
      t.references :receiver, polymorphic: true, index: true
      t.string :notifiable_types
      t.integer :showtime
      t.boolean :accept_email, default: true
      t.timestamps
    end
  end
end
