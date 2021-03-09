defmodule IntegrationTestsTest do
  use ExUnit.Case
  doctest IntegrationTests

  test "greets the world" do
    assert IntegrationTests.hello() == :world
  end
end
