defmodule SpaceMongers.Models.System do
  use SpaceMongers.Model, [
    name: String.t(),
    symbol: String.t(),
    locations: [Models.Location.t()],
    extra_fields: map()
  ]
end
