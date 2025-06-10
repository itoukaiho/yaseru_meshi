# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

class FatSecretClient
  TOKEN_URL = 'https://oauth.fatsecret.com/connect/token'
  API_URL   = 'https://platform.fatsecret.com/rest/server.api'

  def initialize
    @client_id = ENV.fetch('FATSECRET_CLIENT_ID', nil)
    @client_secret = ENV.fetch('FATSECRET_CLIENT_SECRET', nil)
    @access_token = get_access_token
  end

  # アクセストークン取得
  def get_access_token
    uri = URI.parse(TOKEN_URL)
    request = Net::HTTP::Post.new(uri)
    request.set_form_data(
      'grant_type' => 'client_credentials',
      'scope' => 'basic',
      'client_id' => @client_id,
      'client_secret' => @client_secret
    )

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    result = JSON.parse(response.body)
    result['access_token']
  end

  # 食品検索メソッド
  def search_food(query)
    uri = URI(API_URL)
    params = {
      method: 'foods.search',
      format: 'json',
      search_expression: query
    }
    uri.query = URI.encode_www_form(params)

    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{@access_token}"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    Rails.logger.debug { "🔍 foods.search レスポンス: #{response.body}" } # デバッグ用

    body = JSON.parse(response.body)
    food = Array(body.dig('foods', 'food')).first
    return nil unless food

    get_food_nutrition(food['food_id'])
  end

  # 栄養情報を取得するメソッド
  def get_food_nutrition(food_id)
    uri = URI(API_URL)
    params = {
      method: 'food.get',
      format: 'json',
      food_id: food_id
    }
    uri.query = URI.encode_www_form(params)

    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{@access_token}"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    Rails.logger.debug { "📦 food.get レスポンス: #{response.body}" } # デバッグ用

    body = JSON.parse(response.body)
    food = body['food']
    {
      name: food['food_name'],
      calorie: extract_nutrient(food, 'Energy'),
      protein: extract_nutrient(food, 'Protein'),
      fat: extract_nutrient(food, 'Total Fat'),
      carb: extract_nutrient(food, 'Carbohydrate')
    }
  end

  private

  def extract_nutrient(food, name)
    servings = Array(food.dig('servings', 'serving'))
    first_serving = servings.first
    return nil unless first_serving

    key_map = {
      'Energy' => 'calories',
      'Protein' => 'protein',
      'Total Fat' => 'fat',
      'Carbohydrate' => 'carbohydrate'
    }

    key = key_map[name]
    value = first_serving[key]
    value&.to_f&.round(1)
  end
end
