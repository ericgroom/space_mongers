defmodule SpaceMongers.Parsers do
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
  end

  defp parse_contained_good(nil), do: nil
  defp parse_contained_good(good) when is_map(good) do
    %Models.OwnedShip.ContainedGood{
      good: good["good"],
      quantity: good["quantity"],
      total_volume: good["totalVolume"]
    }
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
  end

  def parse_user_data(nil), do: nil
  def parse_user_data(user_data) when is_map(user_data) do
    %Models.UserData{
      username: user_data["username"],
      credits: user_data["credits"],
      loans: user_data["loans"] |> parse_list(&parse_owned_loan/1),
      ships: user_data["ships"] |> parse_list(&parse_owned_ship/1)
    }
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
  end

  def parse_system(nil), do: nil
  def parse_system(system) when is_map(system) do
    %Models.System{
      name: system["name"],
      symbol: system["symbol"],
      locations: system["locations"] |> parse_list(&parse_location/1)
    }
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
  end

  def parse_order(nil), do: nil
  def parse_order(order) when is_map(order) do
    %Models.Order{
      credits: order["credits"],
      order: order["order"] |> parse_list(&parse_order_item/1),
      ship: order["ship"] |> parse_owned_ship()
    }
  end

  defp parse_order_item(nil), do: nil
  defp parse_order_item(order_item) when is_map(order_item) do
    %Models.Order.OrderItem{
      good: order_item["good"],
      price_per_unit: order_item["pricePerUnit"],
      quantity: order_item["quantity"],
      total: order_item["total"]
    }
  end

  def parse_marketplace_item(nil), do: nil
  def parse_marketplace_item(marketplace_item) when is_map(marketplace_item) do
    %Models.MarketplaceItem{
      symbol: marketplace_item["symbol"],
      price_per_unit: marketplace_item["pricePerUnit"],
      volume_per_unit: marketplace_item["volumePerUnit"],
      quantity_available: marketplace_item["quantityAvailable"]
    }
  end
end
