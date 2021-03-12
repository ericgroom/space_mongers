defmodule SpaceMongers.Models.Order do
  @moduledoc """
  Represents the result of a purchase or sell order.
  """
  use SpaceMongers.Model,
    credits: integer(),
    order: [Models.Order.OrderItem.t()],
    ship: Models.OwnedShip.t(),
    extra_fields: map()
end

defmodule SpaceMongers.Models.Order.OrderItem do
  @moduledoc """
  Represents the item being purchase/sold during an order.
  """
  use SpaceMongers.Model,
    good: String.t(),
    price_per_unit: integer(),
    quantity: integer(),
    total: integer(),
    extra_fields: map()
end
