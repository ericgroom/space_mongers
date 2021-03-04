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

  def loans do
    get("/game/loans") |> unwrap()
  end

  def take_loan(type) do
    post("/users/" <> @username <> "/loans", %{type: type}) |> unwrap()
  end

  defp unwrap(response) do
    {:ok, env} = response
    IO.inspect response
    env.body
  end
end
