# frozen_string_literal: true

class AddAdviceToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :advice, :text
  end
end
