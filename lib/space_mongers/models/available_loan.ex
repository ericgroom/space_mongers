defmodule SpaceMongers.Models.AvailableLoan do
  use SpaceMongers.Model, [
    amount: integer(),
    type: String.t(),
    rate: integer(),
    term_in_days: integer(),
    collateral_required: boolean(),
    extra_fields: map()
  ]
end
