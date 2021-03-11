defmodule SpaceMongers.Models.OwnedLoan do
  defstruct [:id, :repayment_amount, :due, :status, :type, :extra_fields]

  @type t() :: %__MODULE__{
    id: String.t(),
    repayment_amount: integer(),
    due: DateTime.t(),
    status: String.t(),
    type: String.t(),
    extra_fields: map()
  }
end
