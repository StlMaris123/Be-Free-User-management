class CreateForums < ActiveRecord::Migration[6.0]
  def change
    create_table :forums do |t|
      t.string :title
      t.text :body
      t.references :user, null: false, foreign_key: true
    end
  end
end
