## App specific
ARG RUBY_VERSION=3.2.4
FROM ruby:$RUBY_VERSION-alpine AS base

WORKDIR /rails

RUN apk update && \
    apk add --no-cache openssl tzdata curl mimalloc yaml zlib-ng vips libpq

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    LD_PRELOAD="/usr/lib/libmimalloc.so.2 /usr/lib/zlib-ng.so.2" \
    TZ="Europe/Budapest"

FROM base AS build

# Generic system-level build tooling
RUN apk update && \
    apk add --no-cache pkgconf unzip git build-base libpq-dev vips-dev

# Ruby tooling & packages
COPY Gemfile Gemfile.lock ./
RUN bundle install --frozen && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Javascrip tooling & packages
ARG NODE_VERSION=20.17.0
ARG YARN_VERSION=1.22.19
ENV PATH=/usr/local/node/bin:$PATH

COPY package.json yarn.lock ./
RUN apk update && \
    apk add nodejs npm && \
    npm install -g yarn@$YARN_VERSION && \
    yarn install --frozen-lockfile

COPY . .

# Adjust binfiles to be executable on Linux
RUN chmod +x bin/* && \
    sed -i "s/\r$//g" bin/* && \
    sed -i 's/ruby\.exe$/ruby/' bin/*

# Precompile everything
RUN bundle exec bootsnap precompile --gemfile && \
    bundle exec bootsnap precompile app/ lib/ && \
    SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

FROM base

COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN addgroup -g 1000 -S rails && \
    adduser -u 1000 -G rails -S -s /bin/ash rails && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 5000
CMD ["/rails/bin/bundle", "exec", "puma", "-e", "production", "-p", "5000", "-C", "config/puma.rb"]

HEALTHCHECK CMD [ "curl", "-f", "http://localhost:5000/up" ]
