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

# Server setup
ENV PORT=4000
ENV MIX_ENV=prod

CMD mix deps.get --only prod
CMD mix compile

# Compile assets
CMD mix assets.deploy

# Custom tasks (like DB migrations)
CMD mix ecto.migrate

# Finally run the server
CMD mix phx.server