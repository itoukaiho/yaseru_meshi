# frozen_string_literal: true

class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @favorite = current_user.favorites.new(post: @post)
    if @favorite.save
      respond_to do |format|
        format.html { redirect_to posts_path, notice: 'お気に入り登録しました' }
        format.js # create.js.erb で非同期対応
      end
    else
      # すでにお気に入り登録済みなどの処理
      head :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @favorite = current_user.favorites.find_by(post: @post)
    if @favorite&.destroy
      respond_to do |format|
        format.html { redirect_to posts_path, notice: 'お気に入り解除しました' }
        format.js # destroy.js.erb で非同期対応
      end
    else
      head :not_found
    end
  end
end
