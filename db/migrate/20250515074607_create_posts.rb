# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.integer :calorie
      t.integer :protein
      t.integer :fat
      t.integer :carb
      t.integer :price
      t.string :store
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
