# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_post, only: %i[show edit update]
  before_action :correct_user, only: %i[edit update]

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result.includes(:user).order(created_at: :desc).page(params[:page]).per(9)
  end

  def show; end

  def new
    @post = Post.new
  end

  def edit; end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      # AIコメント生成
      ai_comment = AiCommentService.generate_comment(@post.title) # または @post.comment や他のカラム
      @post.update(ai_comment: ai_comment) if ai_comment.present?
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

  def destroy
    @post = Post.find(params[:id])
    if @post.user == current_user
      @post.destroy
      redirect_to posts_path, notice: '投稿を削除しました。'
    else
      redirect_to posts_path, alert: '削除できません。'
    end
  end

  def ranking
    @popular_posts = Post.popular.limit(10)
  end

  class Api::PostsController < ApplicationController
    protect_from_forgery with: :null_session # JSから叩く用
  
    def generate_advice
      post = Post.find(params[:id])
  
      client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
  
      prompt = <<~PROMPT
        あなたは栄養士です。
        以下の料理を低カロリーにする具体的なアドバイスを2〜3個提案してください。
  
        料理名: #{post.title}
      PROMPT
  
      response = client.chat(
        parameters: {
          model: "gpt-4o", # または "gpt-4-turbo"
          messages: [
            { role: "user", content: prompt }
          ],
          temperature: 0.7
        }
      )
  
      advice = response.dig("choices", 0, "message", "content")
      post.update(advice: advice)
  
      render json: { advice: advice }
    rescue => e
      render json: { error: e.message }, status: 500
    end
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
