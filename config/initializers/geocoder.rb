Geocoder.configure(
  timeout: 10, # デフォルトは3秒。APIが遅い場合は5〜10に上げると安定することがある
  lookup: :google, # 使用しているジオコーディングサービス（Google Maps なら :google）
  api_key: ENV['GOOGLE_MAPS_API_KEY'], # 必要ならAPIキー設定
  use_https: true,
  units: :km,
  language: :ja,
)
