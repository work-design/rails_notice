class CreateNotificationSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :notification_settings do |t|
      t.references :receiver, polymorphic: true, index: true
      t.references :notifiable, polymorphic: true
      t.integer :showtime
      t.boolean :accept_email
      t.timestamps
    end
  end
end
