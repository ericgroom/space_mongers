import Config

config :logger,
  level: :info

config :tesla, adapter: Tesla.Adapter.Hackney

config :space_mongers, adapter: SpaceMongers.SpaceTraders.Real
