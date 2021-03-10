defmodule SpaceMongers.Parsers do
  def parse_date(nil), do: nil
  def parse_date(iso_str) when is_binary(iso_str) do
    case NaiveDateTime.from_iso8601(iso_str) do
      {:ok, datetime} -> datetime
      {:error, _reason} -> iso_str
    end
  end
end
