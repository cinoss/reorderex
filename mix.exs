defmodule Reorderex.MixProject do
  @moduledoc false
  use Mix.Project

  def project do
    [
      app: :reorderex,
      version: "0.1.3",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      deps: deps(),
      name: "Reorderex",
      source_url: "https://github.com/cinoss/reorderex",
      test_coverage: [tool: ExCoveralls],
      elixirc_paths: elixirc_paths(Mix.env()),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  def application do
    application(Mix.env())
  end

  def application(:test) do
    [
      mod: {Reorderex.TestApplication, []},
      extra_applications: [:logger, :postgrex]
    ]
  end

  def application(_) do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:mix_test_watch, "~> 0.8", only: [:dev, :test], runtime: false},
      {:stream_data, "~> 0.4.3", only: [:test, :dev]},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:postgrex, ">= 0.0.0", optional: true},
      {:ecto_sql, "~> 3.0"},
      {:ecto, ">= 3.0.0"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp description() do
    "An elixir helper library for database list reordering functionality"
  end

  defp package() do
    [
      name: "reorderex",
      files: ~w(lib .formatter.exs mix.exs README*),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/cinoss/reorderex"}
    ]
  end
end
