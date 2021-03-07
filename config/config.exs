import Config

# config :space_traders,
#   username: "replace in other env",
#   token: "replace in other env"

config :logger,
  level: :info

config :tesla, adapter: Tesla.Adapter.Hackney

config :tesla, Tesla.Middleware.Logger,
  debug: false,
  filter_headers: ["authorization"]

import_config("#{Mix.env()}.config.exs")
