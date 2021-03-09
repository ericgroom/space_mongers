defmodule IntegrationTests do
  use ExUnit.Case

  describe "SpaceMongers" do
    test "can get server status" do
      assert {:ok, user_info} = SpaceMongers.claim_username(Utils.random_username())
      %{"user" => %{"username" => username}, "token" => token} = user_info
      client = SpaceMongers.ApiClient.new(username, token)
      assert {:ok, "spacetraders is currently online and available to play"} = SpaceMongers.status(client)
    end

    test "can create user" do
      username = Utils.random_username()
      assert {:ok, %{"user" => %{"username" => ^username}}} = SpaceMongers.claim_username(username)
    end
  end
end
