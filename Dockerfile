FROM elixir:1.14.2-alpine

WORKDIR /app/

RUN apk add make gcc alpine-sdk
COPY . /app/
RUN yes | mix deps.get
COPY docker-entrypoint.sh /

ENTRYPOINT [ "mix", "phx.server" ]
