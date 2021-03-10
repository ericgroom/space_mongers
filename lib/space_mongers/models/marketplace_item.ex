defmodule SpaceMongers.Models.MarketplaceItem do
  defstruct [:symbol, :price_per_unit, :volume_per_unit, :quantity_available]

  @type t() :: %__MODULE__{
    symbol: String.t(),
    price_per_unit: integer(),
    volume_per_unit: integer(),
    quantity_available: integer()
  }
end
