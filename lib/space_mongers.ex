defmodule SpaceMongers do
  @moduledoc """
  Simple API wrapper for spacetraders.io

  Most functions in this module require a `SpaceMongers.ApiClient` instance. More detailed information on
  which endpoints are available is at https://api.spacetraders.io/

  All function calls here are automatically rate-limited to avoid overloading the servers and getting your user
  banned. Right now the rate limiting is quite agressive so expect SpaceMongers to become more efficient in the future.
  """
  alias SpaceMongers.{ApiClient, FullResponse, SpaceTraders, Models, Parsers}
  import SpaceMongers.Formatters, only: [format_response: 3]

  @type client() :: ApiClient.t()
  @type response(t) :: {:ok, t} | {:ok, FullResponse.t()} | {:error, any()}
  @type options() :: [skip_deserialization: boolean()]

  @default_system "OE"

  @doc """
  Get the status of the spacetraders.io servers

  GET /game/status
  """
  @spec status(client(), options()) :: response(String.t())
  def status(client, opts \\ []) do
    # TODO just use unauthenticated client
    SpaceTraders.status(client)
    |> format_response(fn env -> env.body["status"] end, opts)
  end

  @doc """
  Claim a username and obtain an auth token which can be used to make an authenticated client.

  Make sure you save this token as you cannot reobtain it later!

  POST /users/:username/token
  """
  @spec claim_username(String.t(), options()) :: response(%{token: String.t(), user: Models.User.t()})
  def claim_username(username, opts \\ []) do
    SpaceTraders.claim_username(username)
      |> format_response(fn response ->
        token = response.body["token"]
        user = response.body["user"] |> Parsers.parse_user()
        %{
          token: token,
          user: user
        }
      end, opts)
  end

  @doc """
  Get the user tied to the provided ApiClient

  GET /users/:username
  """
  @spec current_user(client(), options()) :: response(Models.UserData.t())
  def current_user(client, opts \\ []) do
    SpaceTraders.current_user(client)
      |> format_response(fn response ->
        response.body["user"]
          |> Parsers.parse_user_data()
      end, opts)
  end

  @doc """
  Get the ships tied to the provided ApiClient

  GET /users/:username/ships
  """
  @spec my_ships(client(), options()) :: response([Models.OwnedShip.t()])
  def my_ships(client, opts \\ []) do
    SpaceTraders.my_ships(client)
      |> format_response(fn response ->
        response.body["ships"]
          |> Parsers.parse_list(&Parsers.parse_owned_ship/1)
      end, opts)
  end

  @doc """
  Gets the list of all available loans to purchase

  GET /game/loans
  """
  @spec loans(client(), options()) :: response([Models.AvailableLoan.t()])
  def loans(client, opts \\ []) do
    SpaceTraders.loans(client)
      |> format_response(fn response ->
        response.body["loans"]
          |> Parsers.parse_list(&Parsers.parse_available_loan/1)
      end, opts)
  end

  @doc """
  Gets the list of your loans

  GET /users/:username/loans
  """
  @spec my_loans(client(), options()) :: response([Models.OwnedLoan.t()])
  def my_loans(client, opts \\ []) do
    SpaceTraders.my_loans(client)
      |> format_response(fn response ->
        response.body["loans"]
        |> Parsers.parse_list(&Parsers.parse_owned_loan/1)
      end, opts)
  end

  @doc """
  Purchases a loan of a certain type

  POST /users/:username/loans
  """
  @spec buy_loan(client(), String.t(), options()) :: response(Models.UserData.t())
  def buy_loan(client, type, opts \\ []) do
    SpaceTraders.buy_loan(client, type)
      |> format_response(fn response ->
        response.body["user"]
          |> Parsers.parse_user_data()
      end, opts)
  end

  @doc """
  Shows all available ships for purchase. Takes an optional `class` parameter.

  GET /game/ships
  """
  @spec ships(client(), String.t() | nil, options()) :: response([Models.AvailableShip.t()])
  def ships(client, class \\ nil, opts \\ []) do
    SpaceTraders.ships(client, class)
      |> format_response(fn response ->
        response.body["ships"]
          |> Parsers.parse_list(&Parsers.parse_available_ship/1)
      end, opts)
  end

  @doc """
  Purchase a ship. Takes a location, and the type of ship.

  Note that `type` is different than `class`. `type` is like `ZA-MK-II` while `class` is like `MK-II`

  POST /users/:username/ships
  """
  @spec buy_ship(client(), String.t(), String.t(), options()) :: response(Models.UserData.t())
  def buy_ship(client, location, type, opts \\ []) do
    SpaceTraders.buy_ship(client, location, type)
      |> format_response(fn response ->
        response.body["user"]
          |> Parsers.parse_user_data()
      end, opts)
  end

  @doc """
  Shows all known systems.

  GET /game/systems
  """
  @spec systems(client(), options()) :: response([Models.System.t()])
  def systems(client, opts \\ []) do
    SpaceTraders.systems(client)
      |> format_response(fn response ->
        response.body["systems"]
          |> Parsers.parse_list(&Parsers.parse_system/1)
      end, opts)
  end

  @doc """
  Gets information about a particular location.

  GET /game/locations/:symbol
  """
  @spec location_info(client(), String.t(), options()) :: response(Models.Location.t())
  def location_info(client, symbol, opts \\ []) do
    SpaceTraders.location_info(client, symbol)
      |> format_response(fn response ->
        response.body["planet"]
          |> Parsers.parse_location()
      end, opts)
  end

  @doc """
  Gets the locations within a particular system. If system is not passed, it is assumed to be `"OE"`.
  Takes an optional parameter for `type` such as `"PLANET"` or `"ASTEROID"`

  GET /game/systems/:system/locations
  """
  @spec locations(client(), String.t() | nil, String.t(), options()) :: response([Models.Location.t()])
  def locations(client, location_type \\ nil, system \\ @default_system, opts \\ []) do
    SpaceTraders.locations(client, system, location_type)
      |> format_response(fn response ->
        response.body["locations"]
          |> Parsers.parse_list(&Parsers.parse_location/1)
      end, opts)
  end

  @doc """
  Start a flight plan for a particular ship. Takes a ship_id and a destination

  POST /users/:username/flight-plans
  """
  @spec create_flight_plan(client(), String.t(), String.t(), options()) :: response(Models.FlightPlan.t())
  def create_flight_plan(client, ship_id, destination, opts \\ []) do
    SpaceTraders.create_flight_plan(client, ship_id, destination)
      |> format_response(fn response ->
        response.body["flightPlan"]
          |> Parsers.parse_flight_plan()
      end, opts)
  end

  @doc """
  Get an existing flight plan via its id

  GET /users/:username/flight-plans/:id
  """
  @spec view_flight_plan(client(), String.t(), options()) :: response(Models.FlightPlan.t())
  def view_flight_plan(client, flight_plan_id, opts \\ []) do
    SpaceTraders.view_flight_plan(client, flight_plan_id)
      |> format_response(fn response ->
        response.body["flightPlan"]
          |> Parsers.parse_flight_plan()
      end, opts)
  end

  @doc """
  Lists available trades for a particular location

  GET /game/locations/:location/marketplace
  """
  @spec available_trades(client(), String.t(), options()) :: response([Models.MarketplaceItem.t()])
  def available_trades(client, location, opts \\ []) do
    SpaceTraders.available_trades(client, location)
      |> format_response(fn response ->
        get_in(response.body, ["planet", "marketplace"])
        |> Parsers.parse_list(&Parsers.parse_marketplace_item/1)
      end, opts)
  end

  @doc """
  Purchases a particular good at the location where your ship is located

  POST /users/:username/purchase-orders
  """
  @spec buy_goods(client(), String.t(), String.t(), number(), options()) :: response(Models.Order.t())
  def buy_goods(client, ship_id, good, quantity, opts \\ []) do
    SpaceTraders.buy_goods(client, ship_id, good, quantity)
      |> format_response(fn response ->
        response.body
          |> Parsers.parse_order()
      end, opts)
  end

  @doc """
  Sells a particular good at the location of your ship

  POST /users/:username/sell-orders
  """
  @spec sell_goods(client(), String.t(), String.t(), number(), options()) :: response(Models.Order.t())
  def sell_goods(client, ship_id, good, quantity, opts \\ []) do
    SpaceTraders.sell_goods(client, ship_id, good, quantity)
      |> format_response(fn response ->
        response.body
          |> Parsers.parse_order()
      end, opts)
  end
end
