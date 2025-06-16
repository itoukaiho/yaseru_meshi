# frozen_string_literal: true

class AddCommentToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :comment, :text
  end
end
