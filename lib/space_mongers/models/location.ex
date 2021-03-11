defmodule SpaceMongers.Models.Location do
  defstruct [:name, :symbol, :type, :x, :y, :extra_fields]

  @type t() :: %__MODULE__{
    name: String.t(),
    symbol: String.t(),
    type: String.t(),
    x: integer(),
    y: integer(),
    extra_fields: map()
  }
end
