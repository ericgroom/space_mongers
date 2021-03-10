defmodule SpaceMongers.Models.System do
  alias SpaceMongers.Models

  defstruct [:name, :symbol, :locations]

  @type t() :: %__MODULE__{
    name: String.t(),
    symbol: String.t(),
    locations: [Models.Location.t()]
  }
end
