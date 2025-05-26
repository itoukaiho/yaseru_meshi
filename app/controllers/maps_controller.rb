class MapsController < ApplicationController
  def index
    @stores = Post.select(:store).distinct.map(&:store)
    @posts = Post.where.not(latitude: nil, longitude: nil)
  end
end
