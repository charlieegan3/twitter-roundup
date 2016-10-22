FROM ruby

WORKDIR /app

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

ADD ./bundle.tar.gz /
COPY Gemfile* /app/
RUN bundle install && bundle clean
RUN printf '#!/bin/sh\ntar -zcf /app/bundle.tar.gz /usr/local/bundle\n' > /usr/local/bin/bundlecache
RUN chmod +x /usr/local/bin/bundlecache

COPY app/ app/
COPY bin/ bin/
COPY config/ config
