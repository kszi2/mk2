ARG DEBIAN_VERSION=12

FROM debian:$DEBIAN_VERSION-slim AS raw

ARG TRUFFLE_VERSION=24.1.0
ARG TRUFFLE_PLATFORM=amd64

ENV PATH="/opt/truffleruby-$TRUFFLE_VERSION-$TRUFFLE_PLATFORM/bin:$PATH" \
    LANG="en_US.UTF-8"

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y locales build-essential ca-certificates curl tar gzip libz-dev libssl-dev libyaml-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives && \
    sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen && \
    echo "gem: --no-document" > ~/.gemrc

RUN mkdir -p /opt/truffleruby-$TRUFFLE_VERSION-$TRUFFLE_PLATFORM && \
    curl -L https://github.com/oracle/truffleruby/releases/download/graal-$TRUFFLE_VERSION/truffleruby-community-$TRUFFLE_VERSION-linux-$TRUFFLE_PLATFORM.tar.gz | tar xz -C /opt/truffleruby-$TRUFFLE_VERSION-$TRUFFLE_PLATFORM --strip-components=1 && \
    /opt/truffleruby-$TRUFFLE_VERSION-$TRUFFLE_PLATFORM/lib/truffle/post_install_hook.sh

FROM debian:$DEBIAN_VERSION-slim AS base

ARG TRUFFLE_VERSION=24.1.0
ARG TRUFFLE_PLATFORM=amd64

ENV PATH="/opt/truffleruby-$TRUFFLE_VERSION-$TRUFFLE_PLATFORM/bin:$PATH" \
    LANG="en_US.UTF-8" \
    RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y locales && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives && \
    sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen && \
    echo "gem: --no-document" > ~/.gemrc

WORKDIR /rails

COPY --from=raw /opt/truffleruby-$TRUFFLE_VERSION-$TRUFFLE_PLATFORM /opt/truffleruby-$TRUFFLE_VERSION-$TRUFFLE_PLATFORM

FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential curl git libpq-dev libvips pkg-config unzip libyaml-dev nodejs npm && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ARG NODE_VERSION=20.17.0
ARG YARN_VERSION=1.22.19
ENV PATH=/usr/local/node/bin:$PATH
RUN npm install -g yarn@$YARN_VERSION

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Install node modules
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN yarn build && \
    yarn build:css && \
    bundle exec bootsnap precompile app/ lib/

# Adjust binfiles to be executable on Linux
RUN chmod +x bin/* && \
    sed -i "s/\r$//g" bin/* && \
    sed -i 's/ruby\.exe$/ruby/' bin/*

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

FROM base

# Install packages needed for deployment
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libyaml-0-2 libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

# Entrypoint prepares the database.
VOLUME "/var/pg"
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 5000
CMD ["/rails/bin/bundle", "exec", "puma", "-e", "production", "-p", "5000", "-C", "config/puma.rb"]

HEALTHCHECK CMD [ "curl", "-f", "http://localhost:5000/up" ]

