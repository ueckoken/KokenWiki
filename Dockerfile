# https://docs.docker.com/compose/rails/
FROM ruby:3.4 AS base
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update -qq \
    && apt-get install -y \
    ca-certificates \
    default-mysql-client \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*
RUN gem install bundler
RUN npm install -g yarn
WORKDIR /app
COPY ./Gemfile ./Gemfile.lock /app/
RUN bundle install

COPY package.json yarn.lock /app/
RUN yarn install --pure-lockfile
RUN rails javascript:build
COPY . /app

EXPOSE 3000
CMD rails s -p 3000 -b 0.0.0.0
