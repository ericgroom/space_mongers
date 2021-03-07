defmodule SpaceMongers.ApiClient do

  @type t() :: Tesla.Client.t()

  @spec new(String.t(), String.t()) :: t()
  def new(username, token) do
    middleware = [
      Tesla.Middleware.Logger,
      {Tesla.Middleware.BaseUrl, "https://api.spacetraders.io"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"Authorization", "Bearer #{token}"}]},
      {SpaceMongers.PutUsernameMiddleware, username},
      Tesla.Middleware.PathParams
    ]

    Tesla.client(middleware)
  end
end
