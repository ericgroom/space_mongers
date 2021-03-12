defmodule SpaceMongers.Models.OwnedLoan do
  use SpaceMongers.Model,
    id: String.t(),
    repayment_amount: integer(),
    due: DateTime.t(),
    status: String.t(),
    type: String.t(),
    extra_fields: map()
end
