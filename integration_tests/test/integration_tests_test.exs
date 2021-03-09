defmodule IntegrationTests do
  use ExUnit.Case

  describe "SpaceMongers" do
    test "can create user" do
      username = Utils.random_username()
      assert {:ok, %{"user" => %{"username" => ^username}}} = SpaceMongers.claim_username(username)
    end
  end
end
