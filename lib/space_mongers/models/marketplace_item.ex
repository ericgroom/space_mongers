defmodule SpaceMongers.Models.MarketplaceItem do
  use SpaceMongers.Model, [
    symbol: String.t(),
    price_per_unit: integer(),
    volume_per_unit: integer(),
    quantity_available: integer(),
    extra_fields: map()
  ]
end
