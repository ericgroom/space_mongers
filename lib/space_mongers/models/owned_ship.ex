defmodule SpaceMongers.Models.OwnedShip do
  use SpaceMongers.Model, [
    id: binary(),
    location: String.t(),
    x: integer(),
    y: integer(),
    cargo: [__MODULE__.ContainedGood.t()],
    max_cargo: integer(),
    space_available: integer(),
    class: String.t(),
    type: String.t(),
    manufacturer: String.t(),
    speed: integer(),
    weapons: integer(),
    plating: integer(),
    extra_fields: map()
  ]
end

defmodule SpaceMongers.Models.OwnedShip.ContainedGood do
  use SpaceMongers.Model, [
    good: String.t(),
    quantity: integer(),
    total_volume: integer(),
    extra_fields: map()
  ]
end
