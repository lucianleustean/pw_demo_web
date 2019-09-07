# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :pw_demo, PwDemoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "tP0M/O4tpxUrkXVSJHLAgIYzySkoeiieP+D2u6+zQZcjdApaRMTqgLuFhNOHNoiI",
  render_errors: [view: PwDemoWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PwDemo.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :pw_demo, :tortoise,
  client_id: :pw_demo_web,
  user_name: System.get_env("MQTT_USERNAME"),
  password: System.get_env("MQTT_PASSWORD"),
  handler: {PwDemo.Mqtt, []},
  server: {Tortoise.Transport.Tcp, host: "farmer.cloudmqtt.com", port: 17208},
  subscriptions: [{"devices/rpi", 0}]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
