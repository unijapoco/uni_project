class AddResultToTip < ActiveRecord::Migration[6.0]
  def change
    add_column :tips, :result, :integer, default: 0
  end
end
