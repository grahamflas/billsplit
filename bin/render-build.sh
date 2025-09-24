#!/usr/bin/env bash
set -o errexit

# Install Ruby deps
bundle install

# Install JS deps
yarn install --frozen-lockfile

# Build frontend with Vite
yarn build

# Compile Rails assets (Sprockets, if any)
bin/rails assets:precompile
bin/rails assets:clean

# Run migrations
bin/rails db:migrate
