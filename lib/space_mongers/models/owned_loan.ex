defmodule SpaceMongers.Models.OwnedLoan do
  defstruct [:id, :repayment_amount, :due, :status, :type]

  @type t() :: %__MODULE__{
    id: String.t(),
    repayment_amount: integer(),
    due: NaiveDateTime.t(),
    status: String.t(),
    type: String.t()
  }
end
