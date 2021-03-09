defmodule Utils do
  def random_username() do
    length = 16
    chars = "abcdefghijklmnopqrstuvwxyz" |> String.split("")
    Stream.repeatedly(fn -> Enum.random(chars) end)
    |> Enum.take(length)
    |> Enum.join()
  end
end
