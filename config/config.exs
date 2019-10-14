# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :awesome_table,
  ecto_repos: [AwesomeTable.Repo],
  github_token: System.get_env("GITHUB_TOKEN")

# Configures the endpoint
config :awesome_table, AwesomeTableWeb.Endpoint,  
  url: [host: "localhost"],
  secret_key_base: "jutF/9Nda9e/6G75gn7hN23XU6jyvD7Qw1eCsUhO0AAPKQWAoNY37I2xX4363t03",
  render_errors: [view: AwesomeTableWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: AwesomeTable.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: System.get_env("SECRET_SALT")
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :event_bus,
  topics: [
    :updated,
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
