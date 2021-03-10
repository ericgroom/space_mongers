defmodule SpaceMongers.Models.AvailableLoan do
  defstruct [:amount, :type, :rate, :term_in_days, :collateral_required]

  @type t() :: %__MODULE__{
    amount: integer(),
    type: String.t(),
    rate: integer(),
    term_in_days: integer(),
    collateral_required: boolean()
  }
end
