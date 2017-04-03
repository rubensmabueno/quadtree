FROM ruby:2.4

MAINTAINER Rubens Minoru Andako Bueno <rubensmabueno@hotmail.com>

ADD Gemfile /app/
ADD Gemfile.lock /app/

WORKDIR /app

RUN bundle install

ADD . /app

CMD ["rackup", "-o", "0.0.0.0"]
