#!/bin/bash
set -e

# 初回のみ DB 起動まで待つ
if [ "$RAILS_ENV" = "development" ]; then
  echo "Waiting for Postgres..."
  while ! pg_isready -h db -U postgres > /dev/null 2> /dev/null; do
    sleep 1
  done
  echo "Postgres is ready"
fi

# コンテナがクラッシュしないように
exec "$@"
