# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :todolist,
  ecto_repos: [Todolist.Repo]

# Configures the endpoint
config :todolist, TodolistWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Pi9Emv4b7mHawED5/6/R2mq7ux5svy8SXtGWDeUBJh7YGOkLHad0rsxQxUj1KNYd",
  render_errors: [view: TodolistWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Todolist.PubSub,
  live_view: [signing_salt: "k3GVXluh"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
