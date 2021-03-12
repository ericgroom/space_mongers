defmodule SpaceMongers.Model do
  @moduledoc false

  @callback camelcase_keys() :: [String.t()]

  defmacro __using__([{_, _} | _] = fieldspecs) do
    fields = Keyword.keys(fieldspecs)

    quote do
      alias SpaceMongers.Models
      defstruct unquote(fields)
      @type t :: %__MODULE__{unquote_splicing(fieldspecs)}
      @behaviour SpaceMongers.Model
      @detected_camelcase_keys SpaceMongers.Model.camelcase_keys(unquote(fields))

      @doc false
      def camelcase_keys do
        @detected_camelcase_keys
      end
    end
  end

  def camelcase_keys(fields) do
    fields
    |> Stream.reject(fn key -> key in [:__struct__, :extra_fields] end)
    |> Stream.map(&Atom.to_string/1)
    |> Enum.map(fn str ->
      [first | rest] = str |> String.split("_")

      [first | Enum.map(rest, &String.capitalize/1)]
      |> Enum.join()
    end)
  end
end
