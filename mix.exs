defmodule SpaceMongers.MixProject do
  use Mix.Project

  def project do
    [
      app: :space_mongers,
      name: "SpaceMongers",
      version: "0.1.1",
      elixir: "~> 1.11",
      description: "A simple API wrapper for spacetraders.io",
      source_url: "https://github.com/ericgroom/space_mongers",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {SpaceMongers.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~> 1.4.0"},
      {:hackney, "~> 1.17.0"},
      {:jason, ">= 1.0.0"},
      {:ex_doc, "~> 0.23", only: :dev, runtime: false},
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/ericgroom/space_mongers"}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: extras()
    ]
  end

  defp extras do
    [
      "README.md"
    ]
  end
end
