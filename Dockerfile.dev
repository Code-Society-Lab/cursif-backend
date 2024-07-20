FROM elixir:1.14.5

# Install debian packages
RUN apt update \
    && apt install -y build-essential inotify-tools postgresql-client git make gcc \
    && apt clean

ADD . /app

# Install Phoenix packages
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix archive.install --force hex phx_new 1.5.1

WORKDIR /app

CMD mix setup && mix phx.server
