class CreateFavorites < ActiveRecord::Migration[7.1]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end

    add_index :favorites, [:user_id, :post_id], unique: true

    add_column :posts, :favorites_count, :integer, default: 0, null: false
  end
end
