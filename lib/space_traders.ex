defmodule SpaceTraders do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://api.spacetraders.io"
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Query, [token: @token]

  @username Application.fetch_env!(:space_traders, :username)
  @token Application.fetch_env!(:space_traders, :token)

  @default_system "OE"

  def status do
    get("/game/status") |> unwrap()
  end

  def current_user do
    get("/users/" <> @username) |> unwrap()
  end

  def loans do
    get("/game/loans") |> unwrap()
  end

  def take_loan(type) do
    post("/users/" <> @username <> "/loans", %{type: type}) |> unwrap()
  end

  @spec ships(String.t() | nil) :: any
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

  def find_asteroid(system \\ @default_system) do
    get("/game/systems/" <> system <> "/locations", [query: [type: "ASTEROID"]]) |> unwrap()
  end

  def create_flight_plan(ship_id, destination) do
    post("/users/" <> @username <> "/flight-plans", %{shipId: ship_id, destination: destination}) |> unwrap()
  end

  def view_flight_plan(flight_plan_id) do
    get("/users/" <> @username <> "/flight-plans/" <> flight_plan_id) |> unwrap()
  end

  defp unwrap(response) do
    {:ok, env} = response
    env.body
  end
end
