defmodule SpaceMongers.Models.User do
  @moduledoc """
  Represents the user.
  """
  use SpaceMongers.Model,
    id: binary(),
    username: String.t(),
    created_at: DateTime.t(),
    updated_at: DateTime.t(),
    credits: integer(),
    email: String.t(),
    picture: any(),
    extra_fields: map()
end
