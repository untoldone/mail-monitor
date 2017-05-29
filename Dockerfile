FROM ruby:2.3.1

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app
COPY Gemfile.lock /app

RUN bundle install

COPY . .

CMD ruby run.rb