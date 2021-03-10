defmodule SpaceMongers.Parsers do
  alias SpaceMongers.Models
  def parse_date(nil), do: nil
  def parse_date(iso_str) when is_binary(iso_str) do
    case NaiveDateTime.from_iso8601(iso_str) do
      {:ok, datetime} -> datetime
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

  def parse_user_data(nil), do: nil
  def parse_user_data(user_data) when is_map(user_data) do
    %Models.UserData{
      username: user_data["username"],
      credits: user_data["credits"],
      loans: user_data["loans"] |> parse_list(&parse_owned_loan/1),
      ships: user_data["ships"] |> parse_list(&parse_owned_ship/1)
    }
  end
end
