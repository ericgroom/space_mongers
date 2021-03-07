defmodule SpaceMongers do
  alias SpaceMongers.{ApiClient, FullResponse}
  alias SpaceMongers.PointTimeRateLimiter, as: Executor

  @type client() :: ApiClient.t()
  @type response() :: {:ok | :error, any()} | {:ok | :error, any(), FullResponse.t()}
  @type options() :: [include_full_response: boolean()]

  @default_system "OE"
  @default_cost 5

  @spec status(client(), options()) :: response()
  def status(client, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.get(client, "/game/status")
      |> unwrap(fn env -> env.body["status"] end, opts)
    end, @default_cost)
  end

  @spec current_user(client(), options()) :: response()
  def current_user(client, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.get(client, "/users/:username")
      |> unwrap(fn env -> env.body["user"] end, opts)
    end, @default_cost)
  end

  @spec my_ships(client(), options()) :: response()
  def my_ships(client, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.get(client, "/users/:username/ships")
      |> unwrap(fn env -> env.body["ships"] end, opts)
    end, @default_cost)
  end

  @spec loans(client(), options()) :: response()
  def loans(client, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.get(client, "/game/loans")
      |> unwrap(fn env -> env.body["loans"] end, opts)
    end, @default_cost)
  end

  @spec take_loan(client(), String.t(), options()) :: response()
  def take_loan(client, type, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.post(client, "/users/:username/loans", %{type: type}) |> unwrap(opts)
    end, @default_cost)
  end

  @spec ships(client(), String.t() | nil, options()) :: response()
  def ships(client, class \\ nil, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.get(client, "/game/ships", query: [class: class])
      |> unwrap(fn env -> env.body["ships"] end, opts)
    end, @default_cost)
  end

  @spec buy_ship(client(), String.t(), String.t(), options()) :: response()
  def buy_ship(client, location, type, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.post(client, "/users/:username/ships", %{location: location, type: type}) |> unwrap(opts)
    end, @default_cost)
  end

  @spec systems(client(), options()) :: response()
  def systems(client, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.get(client, "/game/systems")
      |> unwrap(fn env -> env.body["systems"] end, opts)
    end, @default_cost)
  end

  @spec location_info(client(), String.t(), options()) :: response()
  def location_info(client, symbol, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.get(client, "/game/locations/" <> symbol)
      |> unwrap(opts)
    end, @default_cost)
  end

  @spec locations(client(), String.t() | nil, String.t(), options()) :: response()
  def locations(client, location_type \\ nil, system \\ @default_system, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.get(client, "/game/systems/" <> system <> "/locations", [query: [type: location_type]])
      |> unwrap(fn env -> env.body["locations"] end, opts)
    end, @default_cost)
  end

  @spec create_flight_plan(client(), String.t(), String.t(), options()) :: response()
  def create_flight_plan(client, ship_id, destination, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.post(client, "/users/:username/flight-plans", %{shipId: ship_id, destination: destination})
      |> unwrap(opts)
    end, @default_cost)
  end

  @spec view_flight_plan(client(), String.t(), options()) :: response()
  def view_flight_plan(client, flight_plan_id, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.get(client, "/users/:username/flight-plans/" <> flight_plan_id)
      |> unwrap(opts)
    end, @default_cost)
  end

  @spec available_trades(client(), String.t(), options()) :: response()
  def available_trades(client, location, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.get(client, "/game/locations/" <> location <> "/marketplace")
      |> unwrap(opts)
    end, @default_cost)
  end

  @spec buy_goods(client(), String.t(), String.t(), number(), options()) :: response()
  def buy_goods(client, ship_id, good, quantity, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.post(client, "/users/:username/purchase-orders", %{
        shipId: ship_id,
        good: good,
        quantity: quantity
      }) |> unwrap(opts)
    end, @default_cost)
  end

  @spec sell_goods(client(), String.t(), String.t(), number(), options()) :: response()
  def sell_goods(client, ship_id, good, quantity, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.post(client, "/users/:username/sell-orders", %{
        shipId: ship_id,
        good: good,
        quantity: quantity
      }) |> unwrap(opts)
    end, @default_cost)
  end

  defp unwrap(response, opts) do
    unwrap(response, fn env -> env.body end, opts)
  end

  defp unwrap(response, extract_success, opts)  do
    case response do
      {:ok, env} ->
        if env.status >= 400 do
          error_response(env)
            |> include_response_if_needed(env, opts)
        else
          {:ok, extract_success.(env)}
            |> include_response_if_needed(env, opts)
        end
      {:error, env} ->
        error_response(env)
          |> include_response_if_needed(env, opts)
    end
  end

  defp error_response(%{body: body}), do: {:error, body["error"]["message"] || body}
  defp include_response_if_needed({result, value}, env, opts) do
    if Keyword.get(opts, :include_full_response, false) do
      {result, value, FullResponse.new(env)}
    else
      {result, value}
    end
  end
end
