class AddUniqueIndexToOns < ActiveRecord::Migration[6.0]
  def change
    add_index :ons, [:tip_id, :user_id], unique: true
  end
end
