defmodule SpaceTraders do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://api.spacetraders.io"
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Headers, [{"Authorization", "Bearer #{@token}"}]

  @username Application.fetch_env!(:space_traders, :username)
  @token Application.fetch_env!(:space_traders, :token)

  @default_system "OE"

  def status do
    get("/game/status") |> unwrap()
  end

  def current_user do
    get("/users/" <> @username) |> unwrap()
  end

  def my_ships do
    get("/users/" <> @username <> "/ships") |> unwrap()
  end

  def loans do
    get("/game/loans") |> unwrap()
  end

  def take_loan(type) do
    post("/users/" <> @username <> "/loans", %{type: type}) |> unwrap()
  end

  def ships(class \\ nil) do
    get("/game/ships", query: [class: class]) |> unwrap()
  end

  def buy_ship(location, type) do
    post("/users/" <> @username <> "/ships", %{location: location, type: type}) |> unwrap()
  end

  def buy_fuel(ship_id, quantity) do
    post("/users/" <> @username <> "/purchase-orders", %{
      shipId: ship_id,
      good: "FUEL",
      quantity: quantity
    }) |> unwrap()
  end

  def systems do
    get("/game/systems") |> unwrap()
  end

  def location_info(symbol) do
    get("/game/locations/" <> symbol) |> unwrap()
  end

  def locations(location_type \\ nil, system \\ @default_system) do
    get("/game/systems/" <> system <> "/locations", [query: [type: location_type]]) |> unwrap()
  end

  def create_flight_plan(ship_id, destination) do
    post("/users/" <> @username <> "/flight-plans", %{shipId: ship_id, destination: destination}) |> unwrap()
  end

  def view_flight_plan(flight_plan_id) do
    get("/users/" <> @username <> "/flight-plans/" <> flight_plan_id) |> unwrap()
  end

  def available_trades(location) do
    get("/game/locations/" <> location <> "/marketplace") |> unwrap()
  end

  def buy_goods(ship_id, good, quantity) do
    post("/users/" <> @username <> "/purchase-orders", %{
      shipId: ship_id,
      good: good,
      quantity: quantity
    }) |> unwrap()
  end

  def sell_goods(ship_id, good, quantity) do
    post("/users/" <> @username <> "/sell-orders", %{
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
