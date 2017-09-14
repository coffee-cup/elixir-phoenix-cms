# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :writing,
  ecto_repos: [Writing.Repo]

# Configures the endpoint
config :writing, WritingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0mmW1T5baG/GJxkcGaTAEF4k41iXZYw6V/KCRzo5cw4vjPaRYuhGqIaWI7L0wvTn",
  render_errors: [view: WritingWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Writing.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ueberauth, Ueberauth,
  base_path: "/auth",
  providers: [
    google: {Ueberauth.Strategy.Google, [
      default_scope: "email profile",
      callback_url: System.get_env("GOOGLE_CALLBACK_URL")
    ]}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET"),
  redirect_uri: System.get_env("GOOGLE_CALLBACK_URL")

# Guardian configuration
config :writing, Writing.Guardian,
  allonpd_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Writing",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  secret_key: System.get_env("GUARDIAN_SECRET") || "fZu4/Vr4nt5B9zN722TPcxB4EWfsmJgugRGkWp2OMr2bWvuGyJ6Ki8scsxm3bRJl",
  serializer: Writing.Guardian

config :writing, Writing.AuthAccessPipeline,
  module: Writing.Guardian,
  error_handler: WritingWeb.AuthController

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
