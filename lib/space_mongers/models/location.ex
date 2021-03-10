defmodule SpaceMongers.Models.Location do
  defstruct [:name, :symbol, :type, :x, :y]

  @type t() :: %__MODULE__{
    name: String.t(),
    symbol: String.t(),
    type: String.t(),
    x: integer(),
    y: integer()
  }
end
