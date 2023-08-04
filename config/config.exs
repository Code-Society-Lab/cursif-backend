# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :cursif,
  ecto_repos: [Cursif.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :cursif, CursifWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: CursifWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Cursif.PubSub,
  live_view: [signing_salt: "Et7vBlOR"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :cursif, Cursif.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Guardian setup
#
# In test and development environment, it is permissible to not generate any secret key for authentification, in that
# case one will be temporarily generate one at startup, but in production you will need to generate one via
# `mix guardian.gen.secret` and that you set it in your environment variables under `CURSIF_SECRET_KEY`.
config :cursif, Cursif.Guardian,
       issuer: "cursif",
       ttl: Application.get_env(:cursif, :ttl, {52, :weeks}),
       secret_key: Application.get_env(:cursif, :secret_key)


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
