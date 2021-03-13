defmodule SpaceMongers.Model do
  @moduledoc false

  @callback camelcase_keys() :: [String.t()]
  @callback ignore_keys() :: [String.t()]
  @optional_callbacks ignore_keys: 0

  defmacro __using__([{_, _} | _] = fieldspecs) do
    fields = Keyword.keys(fieldspecs)

    quote do
      alias SpaceMongers.Models
      defstruct unquote(fields)
      @type t :: %__MODULE__{unquote_splicing(fieldspecs)}
      @behaviour SpaceMongers.Model
      @detected_camelcase_keys SpaceMongers.Model.camelcase_keys(unquote(fields))

      @impl true
      @doc false
      def camelcase_keys do
        @detected_camelcase_keys
      end

      @impl true
      @doc false
      def ignore_keys, do: []

      defoverridable camelcase_keys: 0, ignore_keys: 0
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
