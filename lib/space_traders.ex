defmodule SpaceTraders do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://api.spacetraders.io"
  plug Tesla.Middleware.JSON

  @username Application.fetch_env!(:space_traders, :username)
  @token Application.fetch_env!(:space_traders, :token)

  def status do
    get("/game/status")
  end
end
