class EditUser < ActiveRecord::Migration[6.0]
  def change
    change_column_null :users, :username, false
    remove_index :users, :email
  end
end
