FROM ruby:2.5-alpine

RUN apk --update add --virtual build-deps build-base linux-headers \
  && apk add --no-cache ruby-dev postgresql-dev tzdata git libxml2-dev libxslt-dev imagemagick libsodium-dev bash

WORKDIR /app
COPY Gemfile* ./

RUN gem install bundler \
  && bundle config build.nokogiri --use-system-libraries \
  && bundle install --jobs 20 --retry 5 \
  && apk del build-deps \
  && rm -rf /tmp/* /var/tmp/* /usr/share/man /tmp/* /var/tmp/* /var/cache/apk/* /var/log/* ~/.cache

COPY . .

EXPOSE 3000

CMD rails s -p 3000 -b 0.0.0.0
