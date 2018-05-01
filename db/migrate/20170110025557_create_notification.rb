class CreateNotification < ActiveRecord::Migration[5.0]
  def change
    drop_table :notifications, if_exists: true
    create_table :notifications do |t|
      t.references :receiver, polymorphic: true
      t.references :notifiable, polymorphic: true
      t.string :code
      t.integer :state, default: 0
      t.string :title
      t.string :body, limit: 5000
      t.string :link
      t.datetime :sending_at
      t.datetime :sent_at
      t.string :sent_result
      t.datetime :read_at, index: true
      t.boolean :verbose, default: false
      t.string :cc_emails
      t.timestamps
    end
  end
end
