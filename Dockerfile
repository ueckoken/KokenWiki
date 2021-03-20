# https://docs.docker.com/compose/rails/
FROM ruby:2.5

# https://github.com/nodesource/distributions/blob/master/README.md#installation-instructions
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt update -qq && apt install -y nodejs default-mysql-client && rm -rf /var/lib/apt/lists/*
RUN npm install -g yarn

WORKDIR /app

COPY ./Gemfile /app/Gemfile
COPY ./Gemfile.lock /app/Gemfile.lock
RUN bundle install

COPY ./package.json /app/package.json
COPY ./yarn.lock /app/yarn.lock
RUN yarn install --pure-lockfile

COPY . /app

EXPOSE 3000
CMD rails s -p 3000 -b 0.0.0.0
