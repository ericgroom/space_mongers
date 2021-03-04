defmodule SpaceTraders do
  @username Application.fetch_env!(:space_traders, :username)
  @token Application.fetch_env!(:space_traders, :token)

  def print_info do
    IO.puts @username
    IO.puts @token
  end
end
