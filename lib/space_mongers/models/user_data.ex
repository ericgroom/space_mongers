defmodule SpaceMongers.Models.UserData do
  alias SpaceMongers.Models

  defstruct [:username, :credits, :loans, :ships, :extra_fields]

  @type t :: %__MODULE__{
    username: String.t(),
    credits: integer(),
    loans: [Models.OwnedLoan.t()],
    ships: [Models.OwnedShip.t()],
    extra_fields: map()
  }
end
