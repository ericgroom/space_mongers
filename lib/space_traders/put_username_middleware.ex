defmodule SpaceTraders.PutUsernameMiddleware do
  @moduledoc """
  Places :username in the path_params list
  """
  @behaviour Tesla.Middleware

  @impl Tesla.Middleware
  def call(env, next, username) do
    env
    |> put_username(username)
    |> Tesla.run(next)
  end

  defp put_username(env, username) do
    {_, new_opts} = Keyword.get_and_update(env.opts, :path_params, fn current_value ->
      new_value = Keyword.put(current_value || Keyword.new(), :username, username)
      {current_value, new_value}
    end)
    %{env | opts: new_opts}
  end
end
