defmodule SpaceMongers.Models.UserData do
  alias SpaceMongers.Models

  defstruct [:username, :credits, :loans, :ships]

  @type t :: %__MODULE__{
    username: String.t(),
    credits: integer(),
    loans: [Models.OwnedLoan.t()],
    ships: [Models.OwnedShip.t()]
  }
end
