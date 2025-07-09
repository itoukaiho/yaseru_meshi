# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_post, only: %i[show edit update]
  before_action :correct_user, only: %i[edit update]

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result.includes(:user).order(created_at: :desc)
  end

  def show; end

  def new
    @post = Post.new
  end

  def edit; end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: '投稿が完了しました！'
    else
      render :new
    end
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: '投稿を更新しました。'
    else
      render :edit
    end
  end

  def ranking
    @popular_posts = Post.popular.limit(10)
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def correct_user
    redirect_to posts_path, alert: '権限がありません。' unless @post.user == current_user
  end

  def post_params
    params.require(:post).permit(:title, :calorie, :protein, :fat, :carb, :comment, :price, :store, :image)
  end
end
