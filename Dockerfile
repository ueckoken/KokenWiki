# https://docs.docker.com/compose/rails/
FROM ruby:2.5

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update -qq && apt upgrade -y && apt install -y nodejs default-mysql-client yarn
RUN gem update && gem update --system

WORKDIR /app

COPY ./Gemfile /app/Gemfile
COPY ./Gemfile.lock /app/Gemfile.lock
RUN bundle install

COPY ./package.json /app/package.json
COPY ./yarn.lock /app/yarn.lock
RUN yarn install

COPY . /app

EXPOSE 3000
CMD rails s -p 3000 -b 0.0.0.0
