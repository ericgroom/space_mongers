defmodule SpaceMongers.MixProject do
  use Mix.Project

  def project do
    [
      app: :space_mongers,
      name: "SpaceMongers",
      version: "0.3.0",
      elixir: "~> 1.11",
      description: "A simple API wrapper for spacetraders.io",
      source_url: "https://github.com/ericgroom/space_mongers",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs(),
      dialyzer: dialyzer()
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
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/ericgroom/space_mongers"},
      files: [
        "lib",
        "mix.exs",
        "README*",
        "LICENSE*"
      ]
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: extras(),
      extra_section: "GUIDES",
      groups_for_extras: groups_for_extras(),
      groups_for_modules: groups_for_modules()
    ]
  end

  defp extras do
    [
      "README.md"
    ]
  end

  defp groups_for_extras do
    [Introduction: "README.md"]
  end

  defp groups_for_modules do
    [
      Models: [
        ~r/SpaceMongers\.Models\.*+/
      ]
    ]
  end

  defp dialyzer do
    [
      plt_path: {:no_warn, "priv/plts/dialyzer.plt"}
    ]
  end
end
