defmodule SpaceMongers.Models.Location do
  @moduledoc """
  Represents a location within a system.
  """
  use SpaceMongers.Model,
    name: String.t(),
    symbol: String.t(),
    type: String.t(),
    x: integer(),
    y: integer(),
    extra_fields: map()
end
