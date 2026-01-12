import Config

config :api2spec_fixture_phoenix, Api2specFixturePhoenix.Endpoint,
  url: [host: "localhost"],
  render_errors: [formats: [json: Api2specFixturePhoenix.ErrorJSON]],
  pubsub_server: Api2specFixturePhoenix.PubSub

config :logger, :console, format: "$time $metadata[$level] $message\n"
config :phoenix, :json_library, Jason
