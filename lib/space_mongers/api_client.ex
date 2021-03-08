defmodule SpaceMongers.ApiClient do

  @moduledoc """
  Authenticated client required by most functions.

  The type t() is subject to change, so use individual fields at your own risk.
  """

  @opaque t() :: Tesla.Client.t()

  @doc """
  Creates an ApiClient
  """
  @spec new(String.t(), String.t()) :: t()
  def new(username, token) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.spacetraders.io"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"Authorization", "Bearer #{token}"}]},
      {SpaceMongers.PutUsernameMiddleware, username},
      Tesla.Middleware.PathParams
    ]

    Tesla.client(middleware)
  end
end
