defmodule SpaceMongers.Models.UserData do
  @moduledoc """
  Contains various data about the user
  """
  use SpaceMongers.Model,
    username: String.t(),
    credits: integer(),
    loans: [Models.OwnedLoan.t()],
    ships: [Models.OwnedShip.t()],
    extra_fields: map()
end
