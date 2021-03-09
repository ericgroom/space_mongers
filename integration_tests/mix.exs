defmodule IntegrationTests.MixProject do
  use Mix.Project

  def project do
    [
      app: :space_mongers_integration,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: ["lib", "test/support"],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:space_mongers, path: ".."}
    ]
  end
end
