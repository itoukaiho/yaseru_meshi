# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :favorites
  has_many :liked_users, through: :favorites, source: :user

  geocoded_by :store_address # 後述のメソッド名
  before_validation :fetch_nutrition_info, if: lambda {
    calorie.blank? || protein.blank? || fat.blank? || carb.blank?
  }
  after_validation :geocode, if: :will_save_change_to_store?

  validates :title, :store, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  STORE_OPTIONS = %w[
    セブン ローソン ファミマ 大戸屋 やよい軒 なか卯 すき家
    吉野家 松屋 ガスト サイゼリヤ サブウェイ モスバーガー ロイヤルホスト
  ].freeze

  scope :popular, lambda {
    left_joins(:favorites)
      .group(:id)
      .order('COUNT(favorites.id) DESC')
  }

  def store_address
    {
      'セブン' => '東京都千代田区永田町1-7-1',
      'ローソン' => '東京都港区虎ノ門1-1-1',
      'ファミマ' => '東京都新宿区西新宿1-1-3',
      '大戸屋' => '東京都渋谷区宇田川町21-6',
      'やよい軒' => '東京都中央区銀座2-11-2',
      'なか卯' => '東京都千代田区神田須田町1-6',
      'すき家' => '東京都渋谷区道玄坂2-6-6',
      '吉野家' => '東京都港区新橋2-16-1',
      '松屋' => '東京都中野区中野5-65-6',
      'ガスト' => '東京都文京区本郷1-33-6',
      'サイゼリヤ' => '東京都千代田区外神田1-16-10',
      'サブウェイ' => '東京都港区南青山3-1-31',
      'モスバーガー' => '東京都豊島区東池袋1-2-2',
      'ロイヤルホスト' => '東京都品川区西五反田1-2-8'
    }[store]
  end

  private

  def fetch_nutrition_info
    client = FatSecretClient.new
    result = client.search_food(title)
    return if result.blank?

    self.calorie ||= result[:calorie]
    self.protein ||= result[:protein]
    self.fat     ||= result[:fat]
    self.carb    ||= result[:carb]
  end
end
