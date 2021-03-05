defmodule SpaceTraders.ApiClient do

  @type t() :: Tesla.Client.t()

  @spec new(String.t(), String.t()) :: t()
  def new(username, token) do
    middleware = [
      Tesla.Middleware.Logger,
      {Tesla.Middleware.BaseUrl, "https://api.spacetraders.io"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"Authorization", "Bearer #{token}"}]},
      {SpaceTraders.PutUsernameMiddleware, username},
      Tesla.Middleware.PathParams
    ]

    Tesla.client(middleware)
  end

  @spec new :: t()
  def new() do
    username = Application.fetch_env!(:space_traders, :username)
    token = Application.fetch_env!(:space_traders, :token)
    new(username, token)
  end
end
