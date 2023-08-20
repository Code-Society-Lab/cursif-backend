FROM elixir:1.14.5-alpine

WORKDIR /app/

RUN apk add make gcc alpine-sdk

COPY . /app/

RUN mix local.hex --force && \
    mix local.rebar --force
RUN mix setup

ENTRYPOINT [ "mix", "phx.server" ]
