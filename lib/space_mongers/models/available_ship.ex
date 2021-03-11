defmodule SpaceMongers.Models.AvailableShip do
  defstruct [:class, :type, :manufacturer, :max_cargo, :speed, :weapons, :plating, :purchase_locations, :extra_fields]

  @type t() :: %__MODULE__{
    class: String.t(),
    type: String.t(),
    manufacturer: String.t(),
    max_cargo: integer(),
    speed: integer(),
    weapons: integer(),
    plating: integer(),
    purchase_locations: [%{location: String.t(), price: integer()}],
    extra_fields: map()
  }
end
