defmodule SpaceMongers.Parsers do
  @moduledoc false

  alias SpaceMongers.Models
  def parse_date(nil), do: nil

  def parse_date(iso_str) when is_binary(iso_str) do
    case DateTime.from_iso8601(iso_str) do
      {:ok, datetime, _offset} -> datetime
      {:error, _reason} -> iso_str
    end
  end

  def parse_list(nil, _item_parser), do: nil

  def parse_list(list, item_parser) when is_list(list) do
    Enum.map(list, item_parser)
  end

  def parse_user(nil), do: nil

  def parse_user(user) when is_map(user) do
    %Models.User{
      id: user["id"],
      username: user["username"],
      created_at: user["createdAt"] |> parse_date(),
      updated_at: user["updatedAt"] |> parse_date(),
      credits: user["credits"],
      email: user["email"],
      picture: user["picture"]
    }
    |> with_extra_fields(user)
  end

  def parse_owned_ship(nil), do: nil

  def parse_owned_ship(ship) when is_map(ship) do
    %Models.OwnedShip{
      id: ship["id"],
      location: ship["location"],
      x: ship["x"],
      y: ship["y"],
      cargo: parse_list(ship["cargo"], &parse_contained_good/1),
      max_cargo: ship["maxCargo"],
      space_available: ship["spaceAvailable"],
      class: ship["class"],
      type: ship["type"],
      manufacturer: ship["manufacturer"],
      speed: ship["speed"],
      weapons: ship["weapons"],
      plating: ship["plating"]
    }
    |> with_extra_fields(ship)
  end

  defp parse_contained_good(nil), do: nil

  defp parse_contained_good(good) when is_map(good) do
    %Models.OwnedShip.ContainedGood{
      good: good["good"],
      quantity: good["quantity"],
      total_volume: good["totalVolume"]
    }
    |> with_extra_fields(good)
  end

  def parse_owned_loan(nil), do: nil

  def parse_owned_loan(loan) when is_map(loan) do
    %Models.OwnedLoan{
      id: loan["id"],
      repayment_amount: loan["repaymentAmount"],
      due: loan["due"] |> parse_date(),
      status: loan["status"],
      type: loan["type"]
    }
    |> with_extra_fields(loan)
  end

  def parse_available_loan(nil), do: nil

  def parse_available_loan(loan) when is_map(loan) do
    %Models.AvailableLoan{
      amount: loan["amount"],
      type: loan["type"],
      rate: loan["rate"],
      term_in_days: loan["termInDays"],
      collateral_required: loan["collateralRequired"]
    }
    |> with_extra_fields(loan)
  end

  def parse_user_data(nil), do: nil

  def parse_user_data(user_data) when is_map(user_data) do
    %Models.UserData{
      username: user_data["username"],
      credits: user_data["credits"],
      loans: user_data["loans"] |> parse_list(&parse_owned_loan/1),
      ships: user_data["ships"] |> parse_list(&parse_owned_ship/1)
    }
    |> with_extra_fields(user_data)
  end

  def parse_available_ship(nil), do: nil

  def parse_available_ship(ship) when is_map(ship) do
    %Models.AvailableShip{
      class: ship["class"],
      type: ship["type"],
      manufacturer: ship["manufacturer"],
      max_cargo: ship["maxCargo"],
      speed: ship["speed"],
      weapons: ship["weapons"],
      plating: ship["plating"],
      purchase_locations: ship["purchaseLocations"] |> parse_list(&parse_purchase_location/1)
    }
    |> with_extra_fields(ship)
  end

  defp parse_purchase_location(nil), do: nil

  defp parse_purchase_location(location) when is_map(location) do
    %{
      location: location["location"],
      price: location["price"]
    }
  end

  def parse_location(nil), do: nil

  def parse_location(location) when is_map(location) do
    %Models.Location{
      name: location["name"],
      symbol: location["symbol"],
      type: location["type"],
      x: location["x"],
      y: location["y"]
    }
    |> with_extra_fields(location)
  end

  def parse_system(nil), do: nil

  def parse_system(system) when is_map(system) do
    %Models.System{
      name: system["name"],
      symbol: system["symbol"],
      locations: system["locations"] |> parse_list(&parse_location/1)
    }
    |> with_extra_fields(system)
  end

  def parse_flight_plan(nil), do: nil

  def parse_flight_plan(flight_plan) when is_map(flight_plan) do
    %Models.FlightPlan{
      id: flight_plan["id"],
      ship: flight_plan["ship"],
      destination: flight_plan["destination"],
      departure: flight_plan["departure"],
      distance: flight_plan["distance"],
      fuel_consumed: flight_plan["fuelConsumed"],
      fuel_remaining: flight_plan["fuelRemaining"],
      arrives_at: flight_plan["arrivesAt"] |> parse_date(),
      time_remaining_in_seconds: flight_plan["timeRemainingInSeconds"],
      terminated_at: flight_plan["terminatedAt"] |> parse_date()
    }
    |> with_extra_fields(flight_plan)
  end

  def parse_public_flight_plan(nil), do: nil

  def parse_public_flight_plan(flight_plan) when is_map(flight_plan) do
    %Models.PublicFlightPlan{
      id: flight_plan["id"],
      username: flight_plan["username"],
      to: flight_plan["to"],
      from: flight_plan["from"],
      created_at: flight_plan["createdAt"] |> parse_date(),
      arrives_at: flight_plan["arrivesAt"] |> parse_date(),
      ship_type: flight_plan["shipType"]
    }
    |> with_extra_fields(flight_plan)
  end

  def parse_docked_ship(nil), do: nil

  def parse_docked_ship(ship) when is_map(ship) do
    %Models.DockedShip{
      ship_id: ship["shipId"],
      ship_type: ship["shipType"],
      username: ship["username"]
    }
  end

  def parse_order(nil), do: nil

  def parse_order(order) when is_map(order) do
    %Models.Order{
      credits: order["credits"],
      order: order["order"] |> parse_order_item(),
      ship: order["ship"] |> parse_owned_ship()
    }
    |> with_extra_fields(order)
  end

  defp parse_order_item(nil), do: nil

  defp parse_order_item(order_item) when is_map(order_item) do
    %Models.Order.OrderItem{
      good: order_item["good"],
      price_per_unit: order_item["pricePerUnit"],
      quantity: order_item["quantity"],
      total: order_item["total"]
    }
    |> with_extra_fields(order_item)
  end

  # TODO: remove this clause once they fix the API
  defp parse_order_item([order_item]) do
    parse_order_item(order_item)
  end

  def parse_marketplace_item(nil), do: nil

  def parse_marketplace_item(marketplace_item) when is_map(marketplace_item) do
    %Models.MarketplaceItem{
      symbol: marketplace_item["symbol"],
      price_per_unit: marketplace_item["pricePerUnit"],
      volume_per_unit: marketplace_item["volumePerUnit"],
      quantity_available: marketplace_item["quantityAvailable"]
    }
    |> with_extra_fields(marketplace_item)
  end

  def with_extra_fields(model, map) do
    model_module = model.__struct__
    known_keys = model_module.camelcase_keys()
    {_, extra} = Map.split(map, known_keys)
    {_, without_ignored} = Map.split(extra, model_module.ignore_keys())
    %{model | extra_fields: without_ignored}
  end
end
