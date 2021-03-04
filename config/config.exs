import Config

# config :space_traders,
#   username: "replace in other env",
#   token: "replace in other env"

config :tesla, adapter: Tesla.Adapter.Hackney

import_config("#{Mix.env()}.config.exs")
