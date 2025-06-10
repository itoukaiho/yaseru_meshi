# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def favorites
    @favorite_posts = current_user.liked_posts
  end
end
