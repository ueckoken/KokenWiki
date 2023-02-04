# https://docs.docker.com/compose/rails/
FROM ruby:2.7.3 AS base
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update -qq \
    && apt-get install -y \
    ca-certificates \
    default-mysql-client \
    nodejs \
    && rm -rf /var/lib/apt/lists/*
RUN gem install bundler -v 2.1.4
RUN npm install -g yarn
WORKDIR /app
COPY ./Gemfile ./Gemfile.lock /app/
RUN bundle install --frozen

COPY package.json yarn.lock /app/
RUN yarn install --pure-lockfile
COPY app/javascript/ /app/javascript/
RUN rails javascript:build

COPY . /app

EXPOSE 3000
CMD rails s -p 3000 -b 0.0.0.0
