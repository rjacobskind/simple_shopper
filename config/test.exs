use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :shop_api, ShopAPIWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :shop_api, ShopAPI.Repo,
  username: "postgres",
  password: "postgres",
  database: "shop_api_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :commanded,
  event_store_adapter: Commanded.EventStore.Adapters.InMemory

config :commanded, Commanded.EventStore.Adapters.InMemory,
  serializer: Commanded.Serialization.JsonSerializer
