ARG RUBY_VERSION=3.2.2
FROM ruby:${RUBY_VERSION}-alpine

# Needed to build native gems
RUN apk add --no-cache \
  git \
  make \
  g++ \
  gcc \
  musl-dev

# Needed for kitchen-dokken
RUN apk add --no-cache \
  ncurses \
  rsync

# AWS CLI v2 and ECR login helper
RUN apk add --no-cache \
  aws-cli \
  docker-credential-ecr-login
