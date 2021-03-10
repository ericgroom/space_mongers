defmodule SpaceMongers.FullResponse do
  @moduledoc """
  By default SpaceMongers does some formatting and deserialization, you can access the full
  response for a particular request by passing the keyword argument `skip_deserialization: true`.
  """
  @type t() :: %SpaceMongers.FullResponse{method: atom(), status: number(), url: String.t(), headers: list(), body: map()}

  defstruct [:status, :method, :url, :headers, :body]

  @doc false
  def new(%Tesla.Env{status: status, method: method, url: url, headers: headers, body: body}) do
    %__MODULE__{
      status: status,
      method: method,
      url: url,
      headers: headers,
      body: body
    }
  end
end
