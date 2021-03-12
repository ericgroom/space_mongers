defmodule SpaceMongers.Models.AvailableShip do
  use SpaceMongers.Model, [
    class: String.t(),
    type: String.t(),
    manufacturer: String.t(),
    max_cargo: integer(),
    speed: integer(),
    weapons: integer(),
    plating: integer(),
    purchase_locations: [%{location: String.t(), price: integer()}],
    extra_fields: map()
  ]
end
