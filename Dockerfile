# Keep this version in sync with .ruby-version!
FROM ruby:2.7.1-slim

RUN apt-get update && apt-get install -y \
  git

RUN mkdir app
WORKDIR app

COPY Gemfile Gemfile.lock medusa-client.gemspec ./
COPY lib/medusa/version.rb ./lib/medusa/
RUN gem install bundler && bundle install --jobs 20 --retry 5

# Copy everything else except whatever is listed in .dockerignore.
COPY . ./

EXPOSE 4567

CMD ["bundle", "exec", "rake", "test"]
