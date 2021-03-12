defmodule SpaceMongers.Models.User do
  use SpaceMongers.Model, [
    id: binary(),
    username: String.t(),
    created_at: DateTime.t(),
    updated_at: DateTime.t(),
    credits: integer(),
    email: String.t(),
    picture: any(),
    extra_fields: map()
  ]
end
