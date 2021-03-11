defmodule SpaceMongers.Models.PublicFlightPlan do
  defstruct [:id, :username, :to, :from, :created_at, :arrives_at, :ship_type]

  @type t() :: %__MODULE__{
    id: String.t(),
    username: String.t(),
    to: String.t(),
    from: String.t(),
    created_at: DateTime.t(),
    arrives_at: DateTime.t(),
    ship_type: String.t()
  }
end
