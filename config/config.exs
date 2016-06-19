# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :em_board, EmBoard.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "A7TcPpRW+aFXhc6lFWJ7URz8jVi3ZPnQPZpzVFSybG8hvOEhEImZn2pwbgtWsgRd",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: EmBoard.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures api access
config :em_board, :data,
  api_token: "",
  proxy: ""

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"