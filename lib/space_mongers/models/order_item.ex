defmodule SpaceMongers.Models.Order do
  use SpaceMongers.Model,
    credits: integer(),
    order: [Models.OrderItem.t()],
    ship: Models.OwnedShip.t(),
    extra_fields: map()
end

defmodule SpaceMongers.Models.Order.OrderItem do
  use SpaceMongers.Model,
    good: String.t(),
    price_per_unit: integer(),
    quantity: integer(),
    total: integer(),
    extra_fields: map()
end
