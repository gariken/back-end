FROM ruby:2.4.2-alpine

ENV \
  BUILD_PACKAGES="curl curl-dev ruby-dev build-base git imagemagick nodejs tzdata" \
  DEV_PACKAGES="zlib-dev libxml2-dev libxslt-dev icu-dev yaml-dev postgresql-dev" \
  RUBY_PACKAGES="ruby-json yaml" \
  RAILS_ENV="production" \
  RAKE_ENV="production" \
  APP_HOME="/app"

RUN set -ex && \
  apk --update --upgrade add --no-cache $BUILD_PACKAGES $RUBY_PACKAGES $DEV_PACKAGES && \
  rm -rf /var/cache/apk/* && \
  echo 'gem: --no-document' > /etc/gemrc && \
  gem install bundler && \
  mkdir -p /app && \
  mkdir -p /app/tmp/pids

WORKDIR $APP_HOME
COPY . $APP_HOME

RUN set -ex && \
  bundle install --without development test && \
  bundle clean

EXPOSE 9000

CMD bundle exec puma -C config/puma.rb
