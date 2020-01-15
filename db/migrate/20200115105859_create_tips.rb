class CreateTips < ActiveRecord::Migration[6.0]
  def change
    create_table :tips do |t|
      t.belongs_to :user, foreign_key: true
      t.string :desc
      t.float :odds
      t.integer :stake
      t.text :info

      t.timestamps
    end
  end
end
