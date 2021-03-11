defmodule SpaceMongers.Models.System do
  alias SpaceMongers.Models

  defstruct [:name, :symbol, :locations, :extra_fields]

  @type t() :: %__MODULE__{
    name: String.t(),
    symbol: String.t(),
    locations: [Models.Location.t()],
    extra_fields: map()
  }
end
