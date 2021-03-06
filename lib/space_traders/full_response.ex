defmodule SpaceTraders.FullResponse do
  @type t() :: %SpaceTraders.FullResponse{method: atom(), status: number(), url: String.t(), headers: list(), body: map()}

  defstruct [:status, :method, :url, :headers, :body]

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
