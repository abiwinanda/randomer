use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :randomer, RandomerWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :randomer, Randomer.Repo,
  username: System.get_env("RANDOMER_DB_USERNAME") || "postgres",
  password: System.get_env("RANDOMER_DB_PASSWORD") || "postgres",
  database: System.get_env("RANDOMER_DB_TEST_DATABASE") || "randomer_test",
  hostname: System.get_env("RANDOMER_DB_HOSTNAME") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
