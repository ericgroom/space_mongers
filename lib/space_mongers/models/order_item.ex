defmodule SpaceMongers.Models.Order do
  alias SpaceMongers.Models

  defstruct [:credits, :order, :ship]

  @type t() :: %__MODULE__{
    credits: integer(),
    order: [Models.OrderItem.t()],
    ship: Models.OwnedShip.t()
  }
end

defmodule SpaceMongers.Models.Order.OrderItem do
  defstruct [:good, :price_per_unit, :quantity, :total]

  @type t() :: %__MODULE__{
    good: String.t(),
    price_per_unit: integer(),
    quantity: integer(),
    total: integer()
  }
end
