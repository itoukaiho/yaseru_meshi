class User < ApplicationRecord
  has_many :posts, dependent: :destroy 
  has_many :favorites
  has_many :liked_posts, through: :favorites, source: :post
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
end
