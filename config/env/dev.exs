import Config

# Enable dev routes for dashboard and mailbox
config :badge, dev_routes: true

config :badge, BadgeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "ebpOlN5ZJZJJE3d0h2RnKn7CMR0JJDW4O2AcEM17be7Ja+K+b60UKA4pbOjYEWAB",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:badge, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:badge, ~w(--watch)]}
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  # Include HEEx debug annotations as HTML comments in rendered markup
  debug_heex_annotations: true,
  # Enable helpful, but potentially expensive runtime checks
  enable_expensive_runtime_checks: true
