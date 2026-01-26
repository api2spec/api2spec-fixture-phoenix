import Config

# Note: This app uses Plug.Cowboy directly, not Phoenix.Endpoint.
# The Endpoint, ErrorJSON, and PubSub modules referenced below do not exist.
# config :api2spec_fixture_phoenix, Api2specFixturePhoenix.Endpoint,
#   url: [host: "localhost"],
#   render_errors: [formats: [json: Api2specFixturePhoenix.ErrorJSON]],
#   pubsub_server: Api2specFixturePhoenix.PubSub

config :logger, :console, format: "$time $metadata[$level] $message\n"
config :phoenix, :json_library, Jason
