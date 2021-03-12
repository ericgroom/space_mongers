defmodule SpaceMongers.Models.Location do
  use SpaceMongers.Model, [
    name: String.t(),
    symbol: String.t(),
    type: String.t(),
    x: integer(),
    y: integer(),
    extra_fields: map()
  ]
end
