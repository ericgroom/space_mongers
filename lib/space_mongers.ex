defmodule SpaceMongers do
  @moduledoc """
  Simple API wrapper for spacetraders.io

  Most functions in this module require a `SpaceMongers.ApiClient` instance. More detailed information on
  which endpoints are available is at https://api.spacetraders.io/

  All function calls here are automatically rate-limited to avoid overloading the servers and getting your user
  banned. Right now the rate limiting is quite agressive so expect SpaceMongers to become more efficient in the future.
  """
  alias SpaceMongers.{ApiClient, FullResponse, UnauthenticatedApiClient}
  alias SpaceMongers.PointTimeRateLimiter, as: Executor

  @type client() :: ApiClient.t()
  @type response() :: {:ok | :error, any()} | {:ok | :error, any(), FullResponse.t()}
  @type options() :: [include_full_response: boolean()]

  @default_system "OE"
  @default_cost 5

  @doc """
  Get the status of the spacetraders.io servers

  GET /game/status
  """
  @spec status(client(), options()) :: response()
  def status(client, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.get(client, "/game/status")
      |> format(fn env -> env.body["status"] end, opts)
    end, @default_cost)
  end

  @doc """
  Claim a username and obtain an auth token which can be used to make an authenticated client.

  Make sure you save this token as you cannot reobtain it later!

  POST /users/:username/token
  """
  @spec claim_username(String.t(), options()) :: response()
  def claim_username(username, opts \\ []) do
    Executor.add_job(fn ->
      UnauthenticatedApiClient.post("/users/" <> username <> "/token", %{})
      |> format(opts)
    end, @default_cost)
  end

  @doc """
  Get the user tied to the provided ApiClient

  GET /users/:username
  """
  @spec current_user(client(), options()) :: response()
  def current_user(client, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.get(client, "/users/:username")
      |> format(fn env -> env.body["user"] end, opts)
    end, @default_cost)
  end

  @doc """
  Get the ships tied to the provided ApiClient

  GET /users/:username/ships
  """
  @spec my_ships(client(), options()) :: response()
  def my_ships(client, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.get(client, "/users/:username/ships")
      |> format(fn env -> env.body["ships"] end, opts)
    end, @default_cost)
  end

  @doc """
  Gets the list of all available loans to purchase

  GET /game/loans
  """
  @spec loans(client(), options()) :: response()
  def loans(client, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.get(client, "/game/loans")
      |> format(fn env -> env.body["loans"] end, opts)
    end, @default_cost)
  end

  @doc """
  Gets the list of your loans

  GET /users/:username/loans
  """
  @spec my_loans(client(), options()) :: response()
  def my_loans(client, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.get(client, "/users/:username/loans")
      |> format(fn env -> env.body["loans"] end, opts)
    end, @default_cost)
  end

  @doc """
  Purchases a loan of a certain type

  POST /users/:username/loans
  """
  @spec buy_loan(client(), String.t(), options()) :: response()
  def buy_loan(client, type, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.post(client, "/users/:username/loans", %{type: type}) |> format(opts)
    end, @default_cost)
  end

  @doc """
  Shows all available ships for purchase. Takes an optional `class` parameter.

  GET /game/ships
  """
  @spec ships(client(), String.t() | nil, options()) :: response()
  def ships(client, class \\ nil, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.get(client, "/game/ships", query: [class: class])
      |> format(fn env -> env.body["ships"] end, opts)
    end, @default_cost)
  end

  @doc """
  Purchase a ship. Takes a location, and the type of ship.

  Note that `type` is different than `class`. `type` is like `ZA-MK-II` while `class` is like `MK-II`

  POST /users/:username/ships
  """
  @spec buy_ship(client(), String.t(), String.t(), options()) :: response()
  def buy_ship(client, location, type, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.post(client, "/users/:username/ships", %{location: location, type: type}) |> format(opts)
    end, @default_cost)
  end

  @doc """
  Shows all known systems.

  GET /game/systems
  """
  @spec systems(client(), options()) :: response()
  def systems(client, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.get(client, "/game/systems")
      |> format(fn env -> env.body["systems"] end, opts)
    end, @default_cost)
  end

  @doc """
  Gets information about a particular location.

  GET /game/locations/:symbol
  """
  @spec location_info(client(), String.t(), options()) :: response()
  def location_info(client, symbol, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.get(client, "/game/locations/" <> symbol)
      |> format(opts)
    end, @default_cost)
  end

  @doc """
  Gets the locations within a particular system. If system is not passed, it is assumed to be `"OE"`.
  Takes an optional parameter for `type` such as `"PLANET"` or `"ASTEROID"`

  GET /game/systems/:system/locations
  """
  @spec locations(client(), String.t() | nil, String.t(), options()) :: response()
  def locations(client, location_type \\ nil, system \\ @default_system, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.get(client, "/game/systems/" <> system <> "/locations", [query: [type: location_type]])
      |> format(fn env -> env.body["locations"] end, opts)
    end, @default_cost)
  end

  @doc """
  Start a flight plan for a particular ship. Takes a ship_id and a destination

  POST /users/:username/flight-plans
  """
  @spec create_flight_plan(client(), String.t(), String.t(), options()) :: response()
  def create_flight_plan(client, ship_id, destination, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.post(client, "/users/:username/flight-plans", %{shipId: ship_id, destination: destination})
      |> format(opts)
    end, @default_cost)
  end

  @doc """
  Get an existing flight plan via its id

  GET /users/:username/flight-plans/:id
  """
  @spec view_flight_plan(client(), String.t(), options()) :: response()
  def view_flight_plan(client, flight_plan_id, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.get(client, "/users/:username/flight-plans/" <> flight_plan_id)
      |> format(opts)
    end, @default_cost)
  end

  @doc """
  Lists available trades for a particular location

  GET /game/locations/:location/marketplace
  """
  @spec available_trades(client(), String.t(), options()) :: response()
  def available_trades(client, location, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.get(client, "/game/locations/" <> location <> "/marketplace")
      |> format(opts)
    end, @default_cost)
  end

  @doc """
  Purchases a particular good at the location where your ship is located

  POST /users/:username/purchase-orders
  """
  @spec buy_goods(client(), String.t(), String.t(), number(), options()) :: response()
  def buy_goods(client, ship_id, good, quantity, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.post(client, "/users/:username/purchase-orders", %{
        shipId: ship_id,
        good: good,
        quantity: quantity
      }) |> format(opts)
    end, @default_cost)
  end

  @doc """
  Sells a particular good at the location of your ship

  POST /users/:username/sell-orders
  """
  @spec sell_goods(client(), String.t(), String.t(), number(), options()) :: response()
  def sell_goods(client, ship_id, good, quantity, opts \\ []) do
    Executor.add_job(fn ->
      Tesla.post(client, "/users/:username/sell-orders", %{
        shipId: ship_id,
        good: good,
        quantity: quantity
      }) |> format(opts)
    end, @default_cost)
  end

  defp format(response, opts) do
    format(response, fn env -> env.body end, opts)
  end

  defp format(response, extract_success, opts)  do
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

  defp error_response(%{body: %{"error" => %{"message" => message}}}), do: {:error, message}
  defp error_response(%{body: body}), do: {:error, body}
  defp include_response_if_needed({result, value}, env, opts) do
    if Keyword.get(opts, :include_full_response, false) do
      {result, value, FullResponse.new(env)}
    else
      {result, value}
    end
  end
end
