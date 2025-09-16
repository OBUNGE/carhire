#!/usr/bin/env bash
set -o errexit

# --- Ensure Yarn is available ---
# Corepack comes with Node.js >= 16 and manages Yarn versions
corepack enable
corepack prepare yarn@stable --activate

# --- Install Ruby gems ---
bundle install

# --- Install JS dependencies ---
yarn install --check-files

# --- Build assets ---
bundle exec rake assets:precompile
bundle exec rake assets:clean

# --- Run database migrations ---
bundle exec rake db:migrate
