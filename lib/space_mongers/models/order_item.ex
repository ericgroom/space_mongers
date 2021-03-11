defmodule SpaceMongers.Models.Order do
  alias SpaceMongers.Models

  defstruct [:credits, :order, :ship, :extra_fields]

  @type t() :: %__MODULE__{
    credits: integer(),
    order: [Models.OrderItem.t()],
    ship: Models.OwnedShip.t(),
    extra_fields: map()
  }
end

defmodule SpaceMongers.Models.Order.OrderItem do
  defstruct [:good, :price_per_unit, :quantity, :total, :extra_fields]

  @type t() :: %__MODULE__{
    good: String.t(),
    price_per_unit: integer(),
    quantity: integer(),
    total: integer(),
    extra_fields: map()
  }
end
