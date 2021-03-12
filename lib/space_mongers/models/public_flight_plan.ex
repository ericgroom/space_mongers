defmodule SpaceMongers.Models.PublicFlightPlan do
  @moduledoc """
  Represents a flight plan visible to all users.
  """
  use SpaceMongers.Model,
    id: String.t(),
    username: String.t(),
    to: String.t(),
    from: String.t(),
    created_at: DateTime.t(),
    arrives_at: DateTime.t(),
    ship_type: String.t(),
    extra_fields: map()
end
