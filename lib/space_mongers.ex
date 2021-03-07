defmodule SpaceMongers do
  alias SpaceMongers.{ApiClient, FullResponse}
  alias SpaceMongers.PointTimeRateLimiter, as: Executor

  @type client() :: ApiClient.t()
  @type response() :: {:ok | :error, any(), FullResponse.t()}

  @default_system "OE"
  @default_cost 5

  @spec status(client()) :: response()
  def status(client) do
    Executor.add_job(fn ->
      Tesla.get(client, "/game/status")
      |> unwrap(fn env -> env.body["status"] end)
    end, @default_cost)
  end

  @spec current_user(client()) :: response()
  def current_user(client) do
    Executor.add_job(fn ->
      Tesla.get(client, "/users/:username")
      |> unwrap(fn env -> env.body["user"] end)
    end, @default_cost)
  end

  @spec my_ships(client()) :: response()
  def my_ships(client) do
    Executor.add_job(fn ->
      Tesla.get(client, "/users/:username/ships")
      |> unwrap(fn env -> env.body["ships"] end)
    end, @default_cost)
  end

  @spec loans(client()) :: response()
  def loans(client) do
    Executor.add_job(fn ->
      Tesla.get(client, "/game/loans")
      |> unwrap(fn env -> env.body["loans"] end)
    end, @default_cost)
  end

  @spec take_loan(client(), String.t()) :: response()
  def take_loan(client, type) do
    Executor.add_job(fn ->
      Tesla.post(client, "/users/:username/loans", %{type: type}) |> unwrap()
    end, @default_cost)
  end

  @spec ships(client(), String.t() | nil) :: response()
  def ships(client, class \\ nil) do
    Executor.add_job(fn ->
      Tesla.get(client, "/game/ships", query: [class: class])
      |> unwrap(fn env -> env.body["ships"] end)
    end, @default_cost)
  end

  @spec buy_ship(client(), String.t(), String.t()) :: response()
  def buy_ship(client, location, type) do
    Executor.add_job(fn ->
      Tesla.post(client, "/users/:username/ships", %{location: location, type: type}) |> unwrap()
    end, @default_cost)
  end

  @spec systems(client()) :: response()
  def systems(client) do
    Executor.add_job(fn ->
      Tesla.get(client, "/game/systems")
      |> unwrap(fn env -> env.body["systems"] end)
    end, @default_cost)
  end

  @spec location_info(client(), String.t()) :: response()
  def location_info(client, symbol) do
    Executor.add_job(fn ->
      Tesla.get(client, "/game/locations/" <> symbol)
      |> unwrap()
    end, @default_cost)
  end

  @spec locations(client(), String.t() | nil, String.t()) :: response()
  def locations(client, location_type \\ nil, system \\ @default_system) do
    Executor.add_job(fn ->
      Tesla.get(client, "/game/systems/" <> system <> "/locations", [query: [type: location_type]])
      |> unwrap(fn env -> env.body["locations"] end)
    end, @default_cost)
  end

  @spec create_flight_plan(client(), String.t(), String.t()) :: response()
  def create_flight_plan(client, ship_id, destination) do
    Executor.add_job(fn ->
      Tesla.post(client, "/users/:username/flight-plans", %{shipId: ship_id, destination: destination})
      |> unwrap()
    end, @default_cost)
  end

  @spec view_flight_plan(client(), String.t()) :: response()
  def view_flight_plan(client, flight_plan_id) do
    Executor.add_job(fn ->
      Tesla.get(client, "/users/:username/flight-plans/" <> flight_plan_id)
      |> unwrap()
    end, @default_cost)
  end

  @spec available_trades(client(), String.t()) :: response()
  def available_trades(client, location) do
    Executor.add_job(fn ->
      Tesla.get(client, "/game/locations/" <> location <> "/marketplace")
      |> unwrap()
    end, @default_cost)
  end

  @spec buy_goods(client(), String.t(), String.t(), number()) :: response()
  def buy_goods(client, ship_id, good, quantity) do
    Executor.add_job(fn ->
      Tesla.post(client, "/users/:username/purchase-orders", %{
        shipId: ship_id,
        good: good,
        quantity: quantity
      }) |> unwrap()
    end, @default_cost)
  end

  @spec sell_goods(client(), String.t(), String.t(), number()) :: response()
  def sell_goods(client, ship_id, good, quantity) do
    Executor.add_job(fn ->
      Tesla.post(client, "/users/:username/sell-orders", %{
        shipId: ship_id,
        good: good,
        quantity: quantity
      }) |> unwrap()
    end, @default_cost)
  end

  defp unwrap(response) do
    unwrap(response, fn env -> env.body end)
  end

  defp unwrap(response, extract_success) when is_function(extract_success, 1) do
    case response do
      {:ok, env} ->
        if env.status >= 400 do
          error_response(env)
        else
          {:ok, extract_success.(env), FullResponse.new(env)}
        end
      {:error, env} ->
        error_response(env)
    end
  end

  defp error_response(%Tesla.Env{body: body} = env), do: {:error, body["error"]["message"] || body, FullResponse.new(env)}
end
