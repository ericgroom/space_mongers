defmodule SpaceTraders do
  alias SpaceTraders.ApiClient

  @type client() :: ApiClient.t()
  @type response() :: any()

  @default_system "OE"

  @spec status(client()) :: response()
  def status(client) do
    Tesla.get(client, "/game/status") |> unwrap()
  end

  @spec current_user(client()) :: response()
  def current_user(client) do
    Tesla.get(client, "/users/:username") |> unwrap()
  end

  @spec my_ships(client()) :: response()
  def my_ships(client) do
    Tesla.get(client, "/users/:username/ships") |> unwrap()
  end

  @spec loans(client()) :: response()
  def loans(client) do
    Tesla.get(client, "/game/loans") |> unwrap()
  end

  @spec take_loan(client(), String.t()) :: response()
  def take_loan(client, type) do
    Tesla.post(client, "/users/:username/loans", %{type: type}) |> unwrap()
  end

  @spec ships(client(), String.t() | nil) :: response()
  def ships(client, class \\ nil) do
    Tesla.get(client, "/game/ships", query: [class: class]) |> unwrap()
  end

  @spec buy_ship(client(), String.t(), String.t()) :: response()
  def buy_ship(client, location, type) do
    Tesla.post(client, "/users/:username/ships", %{location: location, type: type}) |> unwrap()
  end

  @spec systems(client()) :: response()
  def systems(client) do
    Tesla.get(client, "/game/systems") |> unwrap()
  end

  @spec location_info(client(), String.t()) :: response()
  def location_info(client, symbol) do
    Tesla.get(client, "/game/locations/" <> symbol) |> unwrap()
  end

  @spec locations(client(), String.t() | nil, String.t()) :: response()
  def locations(client, location_type \\ nil, system \\ @default_system) do
    Tesla.get(client, "/game/systems/" <> system <> "/locations", [query: [type: location_type]]) |> unwrap()
  end

  @spec create_flight_plan(client(), String.t(), String.t()) :: response()
  def create_flight_plan(client, ship_id, destination) do
    Tesla.post(client, "/users/:username/flight-plans", %{shipId: ship_id, destination: destination}) |> unwrap()
  end

  @spec view_flight_plan(client(), String.t()) :: response()
  def view_flight_plan(client, flight_plan_id) do
    Tesla.get(client, "/users/:username/flight-plans/" <> flight_plan_id) |> unwrap()
  end

  @spec available_trades(client(), String.t()) :: response()
  def available_trades(client, location) do
    Tesla.get(client, "/game/locations/" <> location <> "/marketplace") |> unwrap()
  end

  @spec buy_goods(client(), String.t(), String.t(), number()) :: response()
  def buy_goods(client, ship_id, good, quantity) do
    Tesla.post(client, "/users/:username/purchase-orders", %{
      shipId: ship_id,
      good: good,
      quantity: quantity
    }) |> unwrap()
  end

  @spec sell_goods(client(), String.t(), String.t(), number()) :: response()
  def sell_goods(client, ship_id, good, quantity) do
    Tesla.post(client, "/users/:username/sell-orders", %{
      shipId: ship_id,
      good: good,
      quantity: quantity
    }) |> unwrap()
  end

  defp unwrap(response) do
    {:ok, env} = response
    env.body
  end
end
