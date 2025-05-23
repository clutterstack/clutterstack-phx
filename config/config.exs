# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :clutterstack,
  ecto_repos: [Clutterstack.Repo],
  generators: [timestamp_type: :utc_datetime],
  md_watcher_enabled: false

# Seems to set the level of the logs this app outputs
# config :clutterstack, Clutterstack.Repo,
#   log: :debug


# Configures the endpoint
config :clutterstack, ClutterstackWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: ClutterstackWeb.ErrorHTML, json: ClutterstackWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Clutterstack.PubSub,
  live_view: [signing_salt: "vULUaPAf"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  clutterstack: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ],
  rando: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets/rando --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]


# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  clutterstack: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Try to get rid of mysterious debug-level logging in Clutterstack.Publish.Entry
# Doesn't work
# I don't know what's setting it to `:debug`
config :logger, Clutterstack.Publish.Entry, level: :info

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  level: :info

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
