defmodule SpaceMongers.Models.FlightPlan do
  use SpaceMongers.Model,
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
end
