defmodule SpaceMongers.Models.CreateUserResponse do
  defstruct [:token, :user]

  @type t() :: %__MODULE__{
    token: binary(),
    user: SpaceMongers.Models.User.t()
  }
end
