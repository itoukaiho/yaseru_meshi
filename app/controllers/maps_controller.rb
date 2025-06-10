# frozen_string_literal: true

class MapsController < ApplicationController
  def index
    @stores = Post.distinct.pluck(:store)
    @posts = Post.where.not(latitude: nil, longitude: nil)
  end
end
