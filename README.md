# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Development

Contrary to common Rails practice, instead of relying on Procfile a runit based
devel service directory is provided. This runs everything required for development,
including the Rails server.

To run this, the following tools are required (including all development tools):

- bun (m)
- ruby (m)
- podman (m)
- runit

Those marked with (m) are installable using the provided `mise.toml` using the
mise tool.

Running this will install the postgres container into the running user's podman
image store.

After that, `./devel/run.sh` will launch all development services. If any need
to be restarted, `SVDIR=./devel/svc sv restart <name>` can be used, or just go
and echo `restart` to the control pipe of the service.
To view the logs, `./devel/readlog.sh` can be used; this follows the logs of all
running services.
