import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :cursif, Cursif.Repo,
  username: System.get_env("POSTGRES_USER", "postgres"),
  password: System.get_env("POSTGRES_PASSWORD", "postgres"),
  hostname: System.get_env("POSTGRES_HOST", "localhost"),
  database: System.get_env(
    "POSTGRES_DB",
    "cursif_test#{System.get_env("MIX_TEST_PARTITION")}"
  ),
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :cursif, CursifWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "rt1VrkBwd/Zts0edrg8R45KVZOYR0N1pU6LDoI5NX7T2KbcRz0nEySvfTdLZlA+6",
  server: false

# In test we don't send emails.
config :cursif, Cursif.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :cursif, :secret_key, "test_secret_key"

# Get the client URL from the environment or use a default
config :cursif, 
  client_url: "http://localhost:3000",
  email_from: "cursif@example.com"