defmodule SpaceMongers.Models.AvailableLoan do
  defstruct [:amount, :type, :rate, :term_in_days, :collateral_required, :extra_fields]

  @type t() :: %__MODULE__{
    amount: integer(),
    type: String.t(),
    rate: integer(),
    term_in_days: integer(),
    collateral_required: boolean(),
    extra_fields: map()
  }
end
