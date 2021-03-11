defmodule SpaceMongers.Models.FlightPlan do
  defstruct [:id, :ship, :destination, :departure, :distance, :fuel_consumed, :fuel_remaining, :arrives_at, :time_remaining_in_seconds, :terminated_at, :extra_fields]

  @type t() :: %__MODULE__{
    id: String.t(),
    ship: String.t(),
    destination: String.t(),
    departure: String.t(),
    distance: integer(),
    fuel_consumed: integer(),
    fuel_remaining: integer(),
    arrives_at: DateTime.t(),
    time_remaining_in_seconds: integer(),
    terminated_at: DateTime.t(),
    extra_fields: map()
  }
end
