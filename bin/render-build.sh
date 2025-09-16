#!/usr/bin/env bash
set -o errexit

# Enable Yarn via Corepack (Yarn 4+)
corepack enable
corepack prepare yarn@stable --activate

# Install Ruby gems
bundle install

# Install JS dependencies
yarn install

# Build assets
bundle exec rake assets:precompile
bundle exec rake assets:clean

# Run database migrations
bundle exec rake db:migrate
