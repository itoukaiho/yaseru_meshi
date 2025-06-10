# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @posts = Post.order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: '投稿が完了しました！'
    else
      render :new
    end
  end

  def ranking
    @popular_posts = Post.popular.limit(10)
  end

  private

  def post_params
    params.require(:post).permit(:title, :calorie, :protein, :fat, :carb, :price, :store, :image)
  end
end
