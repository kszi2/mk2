# syntax = docker/dockerfile:1
# check=error=true
ARG RUBY_VERSION=3.4.5

FROM docker.io/ruby:$RUBY_VERSION-alpine AS base
ARG BUILD_ENV

WORKDIR /rails

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    TZ="Europe/Budapest" \
    SKIP_COVERAGE="1"

RUN apk update && \
    apk add --no-cache yaml curl mimalloc libpq tzdata git icu icu-data-full

FROM base AS build

ENV BUN_INSTALL=/usr/local/bun \
    PATH=/usr/local/bun/bin:$PATH

# Add build tooling
RUN apk update && \
    apk add --no-cache yaml-dev pkgconf unzip build-base bash libpq-dev

# Ruby tooling & packges
COPY Gemfile Gemfile.lock ./
RUN bundle config set frozen true && \
    bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# JavaScript tooling & packages
COPY package.json bun.lock ./
RUN curl -fsSL https://bun.sh/install | bash && \
    bun install --frozen-lockfile

COPY . .

# Adjust binfiles to be executable on Linux
RUN chmod +x bin/* && \
    sed -i "s/\r$//g" bin/* && \
    sed -i 's/ruby\.exe$/ruby/' bin/*

# Precompile everything
RUN bun i --frozen-lockfile && \
    bun run build && \
    bun run build:css && \
    bundle exec bootsnap precompile --gemfile && \
    bundle exec bootsnap precompile app/ lib/ && \
    SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

FROM base

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN addgroup -g 1000 -S rails && \
    adduser -u 1000 -G rails -S -s /bin/ash rails && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start server via Thruster by default, this can be overwritten at runtime
EXPOSE 5000
CMD ["./bin/thrust", "./bin/rails", "server"]
