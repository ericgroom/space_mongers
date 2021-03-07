defmodule SpaceMongersTest do
  use ExUnit.Case
  doctest SpaceMongers

  test "greets the world" do
    assert SpaceMongers.hello() == :world
  end
end
