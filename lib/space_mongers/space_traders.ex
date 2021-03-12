defmodule SpaceMongers.SpaceTraders do
  @moduledoc false

  alias SpaceMongers.{ApiClient, FullResponse}

  defp adapter do
    Application.get_env(:space_mongers, :adapter, SpaceMongers.SpaceTraders.Real)
  end

  @type response() :: {:ok, FullResponse.t()} | {:error, any()}

  @callback status() :: response()
  def status, do: adapter().status()

  @callback claim_username(String.t()) :: response()
  def claim_username(username), do: adapter().claim_username(username)

  @callback current_user(ApiClient.t()) :: response()
  def current_user(client), do: adapter().current_user(client)

  @callback my_ships(ApiClient.t()) :: response()
  def my_ships(client), do: adapter().my_ships(client)

  @callback loans(ApiClient.t()) :: response()
  def loans(client), do: adapter().loans(client)

  @callback my_loans(ApiClient.t()) :: response()
  def my_loans(client), do: adapter().my_loans(client)

  @callback buy_loan(ApiClient.t(), String.t()) :: response()
  def buy_loan(client, type), do: adapter().buy_loan(client, type)

  @callback ships(ApiClient.t(), String.t() | nil) :: response()
  def ships(client, class), do: adapter().ships(client, class)

  @callback buy_ship(ApiClient.t(), String.t(), String.t()) :: response()
  def buy_ship(client, location, type), do: adapter().buy_ship(client, location, type)

  @callback systems(ApiClient.t()) :: response()
  def systems(client), do: adapter().systems(client)

  @callback location_info(ApiClient.t(), String.t()) :: response()
  def location_info(client, symbol), do: adapter().location_info(client, symbol)

  @callback locations(ApiClient.t(), String.t(), String.t() | nil) :: response()
  def locations(client, system, location_type),
    do: adapter().locations(client, system, location_type)

  @callback create_flight_plan(ApiClient.t(), String.t(), String.t()) :: response()
  def create_flight_plan(client, ship_id, destination),
    do: adapter().create_flight_plan(client, ship_id, destination)

  @callback view_flight_plan(ApiClient.t(), String.t()) :: response()
  def view_flight_plan(client, flight_plan_id),
    do: adapter().view_flight_plan(client, flight_plan_id)

  @callback flight_plans(ApiClient.t(), String.t()) :: response()
  def flight_plans(client, system), do: adapter().flight_plans(client, system)

  @callback available_trades(ApiClient.t(), String.t()) :: response()
  def available_trades(client, location), do: adapter().available_trades(client, location)

  @callback buy_goods(ApiClient.t(), String.t(), String.t(), integer()) :: response()
  def buy_goods(client, ship_id, good, quantity),
    do: adapter().buy_goods(client, ship_id, good, quantity)

  @callback sell_goods(ApiClient.t(), String.t(), String.t(), integer()) :: response()
  def sell_goods(client, ship_id, good, quantity),
    do: adapter().sell_goods(client, ship_id, good, quantity)
end
