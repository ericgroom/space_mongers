defmodule SpaceMongers.Models.System do
  @moduledoc """
  Represents a system in the galaxy.
  """
  use SpaceMongers.Model,
    name: String.t(),
    symbol: String.t(),
    locations: [Models.Location.t()],
    extra_fields: map()
end
