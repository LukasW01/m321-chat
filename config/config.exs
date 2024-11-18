# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :chat,
  ecto_repos: [Chat.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :chat, ChatWeb.Endpoint,
  url: [
    host: System.get_env("HOSTNAME"),
    port: 4000,
    scheme: "http"
  ],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: ChatWeb.ErrorHTML, json: ChatWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Chat.PubSub,
  live_view: [signing_salt: "4xmMjVUW"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :chat, Chat.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild
config :esbuild,
  version: "0.17.11",
  chat: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind
config :tailwind,
  version: "3.4.3",
  chat: [
    args: ~w(
      --config=tailwind.config.js
      --input=../priv/static/assets/app.css.tailwind
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configure dart_sass
config :dart_sass,
  version: "1.77.8",
  chat: [
    args: ~w(css/app.scss ../priv/static/assets/app.css.tailwind),
    cd: Path.expand("../assets", __DIR__)
  ]

config :chat, :pow,
  web_module: ChatWeb,
  user: Chat.Users.User,
  repo: Chat.Repo

# Configure Sentry
config :sentry,
  dsn:
    "https://8797b3ad38f29843102098e62108fb25@o4506923162533888.ingest.us.sentry.io/4508293270929408",
  environment_name: Mix.env(),
  enable_source_code_context: true,
  root_source_code_paths: [File.cwd!()]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :chat, ChatWeb.Gettext, locales: ~w(de en), default_locale: "de"

# Runtime configuration (defaults for all environments)
config :chat, :pow_assent,
  providers: [
    Keycloak: [
      client_id: System.get_env("OAUTH_CLIENT_ID"),
      client_secret: System.get_env("OAUTH_CLIENT_SECRET"),
      strategy: Chat.Auth.Provider
    ]
  ]

# Configure S3
config :chat,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  bucket: System.get_env("S3_BUCKET"),
  region: System.get_env("AWS_REGION"),
  url: System.get_env("S3_URL"),
  host: System.get_env("S3_ALIAS_HOST")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
