defmodule SpaceMongers.Formatters do
  @moduledoc false

  def format_response(result, extract_success, opts) do
    skip_deserialization = Keyword.get(opts, :skip_deserialization, false)

    case result do
      {:ok, response} ->
        if response.status >= 400 do
          error_response(response, skip_deserialization)
        else
          success_response(response, extract_success, skip_deserialization)
        end

      {:error, reason} ->
        error_response(reason, skip_deserialization)
    end
  end

  defp success_response(full_response, deserialize, skip_deserialization)
  defp success_response(response, _deserialize, true), do: {:ok, response}
  defp success_response(response, deserialize, false), do: {:ok, deserialize.(response)}

  defp error_response(full_response, skip_deserialization)
  defp error_response(response, true), do: {:error, response}

  defp error_response(%{body: %{"error" => %{"message" => message}}}, false),
    do: {:error, message}

  defp error_response(%{body: body}, false), do: {:error, body}
  defp error_response(reason, _), do: {:error, reason}
end
