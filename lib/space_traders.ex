defmodule SpaceTraders do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://api.spacetraders.io"
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Query, [token: @token]

  @username Application.fetch_env!(:space_traders, :username)
  @token Application.fetch_env!(:space_traders, :token)

  def status do
    get("/game/status") |> unwrap()
  end

  def current_user do
    get("/users/" <> @username) |> unwrap()
  end

  defp unwrap(response) do
    {:ok, env} = response
    env.body
  end
end
