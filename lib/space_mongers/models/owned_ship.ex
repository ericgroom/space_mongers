defmodule SpaceMongers.Models.OwnedShip do
  defstruct [:id, :location, :x, :y, :cargo, :max_cargo, :space_available, :class, :type, :manufacturer, :speed, :weapons, :plating, :extra_fields]

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
    plating: integer(),
    extra_fields: map()
  }
end

defmodule SpaceMongers.Models.OwnedShip.ContainedGood do
  defstruct [:good, :quantity, :total_volume, :extra_fields]

  @type t() :: %__MODULE__{
    good: String.t(),
    quantity: integer(),
    total_volume: integer(),
    extra_fields: map()
  }
end
