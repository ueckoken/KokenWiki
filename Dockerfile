FROM node:23 AS node
WORKDIR /app

COPY package.json yarn.lock /app/
RUN yarn install --pure-lockfile

COPY . /app
RUN yarn build

FROM ruby:3.3 AS base
RUN apt-get update -qq \
    && apt-get install -y \
    ca-certificates \
    default-mysql-client \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*
RUN gem install bundler -v 2.6.8
RUN npm install -g yarn
WORKDIR /app
COPY ./Gemfile ./Gemfile.lock /app/
RUN bundle install

COPY . /app
COPY --from=node /app/javascript/application.js /app/javascript/application.js

RUN rails javascript:build

EXPOSE 3000
CMD rails s -p 3000 -b 0.0.0.0
