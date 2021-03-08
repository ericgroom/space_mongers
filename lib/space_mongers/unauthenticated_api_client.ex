defmodule SpaceMongers.UnauthenticatedApiClient do
  @moduledoc false

  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://api.spacetraders.io"
  plug Tesla.Middleware.JSON
end
