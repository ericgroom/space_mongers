defmodule SpaceMongers.SpaceTraders do
  @moduledoc false

  alias SpaceMongers.{ApiClient, FullResponse}
  @delegate SpaceMongers.SpaceTraders.Real # TODO config

  @type response() :: {:ok, FullResponse.t()} | {:error, any()}

  @callback status(ApiClient.t()) :: response()
  def status(client), do: @delegate.status(client)

  @callback claim_username(String.t()) :: response()
  def claim_username(username), do: @delegate.claim_username(username)

  @callback current_user(ApiClient.t()) :: response()
  def current_user(client), do: @delegate.current_user(client)

  @callback my_ships(ApiClient.t()) :: response()
  def my_ships(client), do: @delegate.my_ships(client)

  @callback loans(ApiClient.t()) :: response()
  def loans(client), do: @delegate.loans(client)

  @callback my_loans(ApiClient.t()) :: response()
  def my_loans(client), do: @delegate.my_loans(client)

  @callback buy_loan(ApiClient.t(), String.t()) :: response()
  def buy_loan(client, type), do: @delegate.buy_loan(client, type)

  @callback ships(ApiClient.t(), String.t() | nil) :: response()
  def ships(client, class), do: @delegate.ships(client, class)

  @callback buy_ship(ApiClient.t(), String.t(), String.t()) :: response()
  def buy_ship(client, location, type), do: @delegate.buy_ship(client, location, type)

  @callback systems(ApiClient.t()) :: response()
  def systems(client), do: @delegate.systems(client)

  @callback location_info(ApiClient.t(), String.t()) :: response()
  def location_info(client, symbol), do: @delegate.location_info(client, symbol)

  @callback locations(ApiClient.t(), String.t(), String.t() | nil) :: response()
  def locations(client, system, location_type), do: @delegate.locations(client, system, location_type)

  @callback create_flight_plan(ApiClient.t(), String.t(), String.t()) :: response()
  def create_flight_plan(client, ship_id, destination), do: @delegate.create_flight_plan(client, ship_id, destination)

  @callback view_flight_plan(ApiClient.t(), String.t()) :: response()
  def view_flight_plan(client, flight_plan_id), do: @delegate.view_flight_plan(client, flight_plan_id)

  @callback available_trades(ApiClient.t(), String.t()) :: response()
  def available_trades(client, location), do: @delegate.available_trades(client, location)

  @callback buy_goods(ApiClient.t(), String.t(), String.t(), integer()) :: response()
  def buy_goods(client, ship_id, good, quantity), do: @delegate.buy_goods(client, ship_id, good, quantity)

  @callback sell_goods(ApiClient.t(), String.t(), String.t(), integer()) :: response()
  def sell_goods(client, ship_id, good, quantity), do: @delegate.sell_goods(client, ship_id, good, quantity)
end
