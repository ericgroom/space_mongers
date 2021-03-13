defmodule SpaceMongers.Models.DockedShip do
  use SpaceMongers.Model,
    ship_id: String.t(),
    ship_type: String.t(),
    username: String.t()
end
