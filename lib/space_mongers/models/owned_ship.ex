defmodule SpaceMongers.Models.OwnedShip do
  defstruct [:id, :location, :x, :y, :cargo, :max_cargo, :space_available, :class, :type, :manufacturer, :speed, :weapons, :plating]

  @type t() :: %__MODULE__{
    id: binary(),
    location: String.t(),
    x: integer(),
    y: integer(),
    cargo: [__MODULE__.ContainedGood.t()],
    max_cargo: integer(),
    space_available: integer(),
    class: String.t(),
    type: String.t(),
    manufacturer: String.t(),
    speed: integer(),
    weapons: integer(),
    plating: integer()
  }
end

defmodule SpaceMongers.Models.OwnedShip.ContainedGood do
  defstruct [:good, :quantity, :total_volume]

  @type t() :: %__MODULE__{
    good: String.t(),
    quantity: integer(),
    total_volume: integer()
  }
end
