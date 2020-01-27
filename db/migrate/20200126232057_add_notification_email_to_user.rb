class AddNotificationEmailToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :notifications_email, :string
  end
end
