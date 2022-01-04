# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :randomer,
  ecto_repos: [Randomer.Repo]

# Configures the endpoint
config :randomer, RandomerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "04XbpDi4NauDPVCkjyICfBC+ItNTdaiRBjtzqkRdfEqmQJrdUgpC/LT38DNonEz1",
  render_errors: [view: RandomerWeb.ErrorView, accepts: ~w(json)],
  pubsub_server: Randomer.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
