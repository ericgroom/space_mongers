defmodule SpaceMongers.Models.DockedShip do
  @moduledoc """
  Represents a ship docked at a planet visible to all users.
  """
  use SpaceMongers.Model,
    ship_id: String.t(),
    ship_type: String.t(),
    username: String.t()
end
