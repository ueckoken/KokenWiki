FROM node:16 AS prepare-node
WORKDIR /app
COPY ./package.json ./yarn.lock ./
RUN yarn install --pure-lockfile

# https://docs.docker.com/compose/rails/
FROM ruby:2.7
RUN apt-get update -qq \
    && apt-get install -y \
    ca-certificates \
    default-mysql-client \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*
RUN gem install bundler -v 2.1.4
RUN npm install -g yarn
WORKDIR /app

COPY ./Gemfile ./Gemfile.lock /app/

RUN bundle install --frozen
COPY app/javascript/ /app/javascript
COPY --from=prepare-node /app/node_modules /app/node_modules
RUN rails javascript:build
COPY . /app

EXPOSE 3000
CMD rails s -p 3000 -b 0.0.0.0
