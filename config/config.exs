# This file is responsible for configuring your application and its
# dependencies.
#
# This configuration file is loaded before any dependency and is restricted to
# this project.
import Config

# Enable the Nerves integration with Mix
Application.start(:nerves_bootstrap)

config :badge, target: Mix.target(), env: Mix.env()

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Set the SOURCE_DATE_EPOCH date for reproducible builds.
# See https://reproducible-builds.org/docs/source-date-epoch/ for more information

config :nerves, source_date_epoch: "1752650627"

config :badge,
  ecto_repos: [Badge.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :badge, BadgeWeb.Endpoint,
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: BadgeWeb.ErrorHTML, json: BadgeWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Badge.PubSub,
  live_view: [signing_salt: "AuuheQ1f"],
  secret_key_base: "LD+MXE/6g/Fg1QqO5D0rC5ccJisqWAcTqiL2XHH8YalrRQguXSNwW5nv102ABkwV"

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  badge: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  badge: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

if Mix.target() == :host do
  import_config "host.exs"
else
  import_config "target.exs"
end

import_config "env/#{Mix.env()}.exs"
