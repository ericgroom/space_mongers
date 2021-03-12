defmodule SpaceMongers.SpaceTraders.Real do
  @moduledoc false

  @behaviour SpaceMongers.SpaceTraders

  alias SpaceMongers.{FullResponse, UnauthenticatedApiClient}
  alias SpaceMongers.PointTimeRateLimiter, as: Executor

  @default_cost 5

  defmacrop exec(do: block) do
    quote do
      Executor.add_job(fn -> unquote(block) end, unquote(@default_cost))
      |> convert_response()
    end
  end

  def status do
    exec do
      UnauthenticatedApiClient.get("/game/status")
    end
  end

  def claim_username(username) do
    exec do
      UnauthenticatedApiClient.post("/users/" <> username <> "/token", %{})
    end
  end

  def current_user(client) do
    exec do
      Tesla.get(client, "/users/:username")
    end
  end

  def my_ships(client) do
    exec do
      Tesla.get(client, "/users/:username/ships")
    end
  end

  def loans(client) do
    exec do
      Tesla.get(client, "/game/loans")
    end
  end

  def my_loans(client) do
    exec do
      Tesla.get(client, "/users/:username/loans")
    end
  end

  def buy_loan(client, type) do
    exec do
      Tesla.post(client, "/users/:username/loans", %{type: type})
    end
  end

  def ships(client, class) do
    exec do
      Tesla.get(client, "/game/ships", query: [class: class])
    end
  end

  def buy_ship(client, location, type) do
    exec do
      Tesla.post(client, "/users/:username/ships", %{location: location, type: type})
    end
  end

  def scrap_ship(client, ship_id) do
    exec do
      Tesla.delete(client, "/users/:username/ships/" <> ship_id)
    end
  end

  def systems(client) do
    exec do
      Tesla.get(client, "/game/systems")
    end
  end

  def location_info(client, symbol) do
    exec do
      Tesla.get(client, "/game/locations/" <> symbol)
    end
  end

  def locations(client, system, location_type) do
    exec do
      Tesla.get(client, "/game/systems/" <> system <> "/locations", query: [type: location_type])
    end
  end

  def create_flight_plan(client, ship_id, destination) do
    exec do
      Tesla.post(client, "/users/:username/flight-plans", %{
        shipId: ship_id,
        destination: destination
      })
    end
  end

  def view_flight_plan(client, flight_plan_id) do
    exec do
      Tesla.get(client, "/users/:username/flight-plans/" <> flight_plan_id)
    end
  end

  def flight_plans(client, system) do
    exec do
      Tesla.get(client, "/game/systems/" <> system <> "/flight-plans")
    end
  end

  def available_trades(client, location) do
    exec do
      Tesla.get(client, "/game/locations/" <> location <> "/marketplace")
    end
  end

  def buy_goods(client, ship_id, good, quantity) do
    exec do
      Tesla.post(client, "/users/:username/purchase-orders", %{
        shipId: ship_id,
        good: good,
        quantity: quantity
      })
    end
  end

  def sell_goods(client, ship_id, good, quantity) do
    exec do
      Tesla.post(client, "/users/:username/sell-orders", %{
        shipId: ship_id,
        good: good,
        quantity: quantity
      })
    end
  end

  defp convert_response({:ok, %Tesla.Env{} = env}), do: {:ok, FullResponse.new(env)}
  defp convert_response({:error, %Tesla.Env{} = env}), do: {:error, FullResponse.new(env)}
  defp convert_response({:error, any}), do: {:error, any}
end
