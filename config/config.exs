import Config

config :logger,
  level: :info

config :tesla, adapter: Tesla.Adapter.Hackney
