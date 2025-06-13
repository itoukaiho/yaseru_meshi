# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { User.create!(email: 'test@example.com', password: 'password') }

  it 'タイトルがなければ無効' do
    post = described_class.new(title: '', user: user, store: 'セブン', price: 500)
    post.valid?
    expect(post.errors[:title]).to include("を入力してください")
  end

  it 'タイトルがあれば有効' do
    post = described_class.new(
      title: 'ヘルシーサラダ',
      user: user,
      store: 'ローソン',
      price: 480
    )
    expect(post).to be_valid
  end

  it 'storeがなければ無効' do
    post = described_class.new(title: 'サラダ', user: user, store: '', price: 400)
    post.valid?
    expect(post.errors[:store]).to include("を入力してください")
  end

  it 'priceがなければ無効' do
    post = described_class.new(title: 'サラダ', user: user, store: 'ファミマ', price: nil)
    post.valid?
    expect(post.errors[:price]).to include("を入力してください")
  end

  it 'priceが0円未満だと無効' do
    post = described_class.new(title: '弁当', user: user, store: 'ローソン', price: -100)
    post.valid?
    expect(post.errors[:price]).to include("は0以上で入力してください")
  end
end
