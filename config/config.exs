import Config

config :logger,
  level: :info

config :tesla, adapter: Tesla.Adapter.Hackney

config :tesla, Tesla.Middleware.Logger,
  debug: false,
  filter_headers: ["authorization"]
