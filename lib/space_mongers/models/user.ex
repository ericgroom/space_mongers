defmodule SpaceMongers.Models.User do
  defstruct [:id, :username, :created_at, :updated_at, :credits, :email, :picture, :extra_fields]

  @type t() :: %__MODULE__{
    id: binary(),
    username: String.t(),
    created_at: DateTime.t(),
    updated_at: DateTime.t(),
    credits: integer(),
    email: String.t(),
    picture: any(),
    extra_fields: map()
  }
end
