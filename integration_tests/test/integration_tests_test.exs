defmodule IntegrationTests do
  use ExUnit.Case, async: true

  describe "SpaceMongers" do
    test "can get server status" do
      client = make_client()
      assert {:ok, "spacetraders is currently online and available to play"} = SpaceMongers.status(client)
    end

    test "can create user" do
      username = Utils.random_username()
      assert {:ok, %{"user" => %{"username" => ^username}}} = SpaceMongers.claim_username(username)
    end

    test "can take out a loan" do
      client = make_client()
      assert {:ok, _loan} = SpaceMongers.buy_loan(client, "STARTUP")
    end

    defp make_client() do
      assert {:ok, user_info} = SpaceMongers.claim_username(Utils.random_username())
      %{"user" => %{"username" => username}, "token" => token} = user_info
      SpaceMongers.ApiClient.new(username, token)
    end
  end
end
