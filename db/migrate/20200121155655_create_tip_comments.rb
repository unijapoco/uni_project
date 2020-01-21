class CreateTipComments < ActiveRecord::Migration[6.0]
  def change
    create_table :tip_comments do |t|
      t.belongs_to :tip, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
