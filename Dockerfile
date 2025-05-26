FROM ruby:3.0.4

# 必要パッケージのインストール
RUN apt-get update -qq && apt-get install -y \
  build-essential libpq-dev nodejs default-mysql-client yarn

# 作業ディレクトリ作成
WORKDIR /app

# Gemfile追加
COPY Gemfile Gemfile.lock ./
RUN bundle install

# アプリ全体コピー
COPY . .

# Entrypoint設定
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
