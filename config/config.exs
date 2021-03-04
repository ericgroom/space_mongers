import Config

# config :space_traders,
#   username: "replace in other env",
#   token: "replace in other env"

import_config("#{Mix.env()}.config.exs")
