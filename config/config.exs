# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :shop_api,
  namespace: ShopAPI,
  ecto_repos: [ShopAPI.Repo]

config :commanded_ecto_projections,
  repo: ShopAPI.Repo

# Configures the endpoint
config :shop_api, ShopAPIWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "j/poKai3LIhoos6YAGsSlonIdfrJJ7sxnh+RMDk6qR+D2yEzhbtJneUUCk1QJV1G",
  render_errors: [view: ShopAPIWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: ShopAPI.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :commanded,
  event_store_adapter: Commanded.EventStore.Adapters.EventStore

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
