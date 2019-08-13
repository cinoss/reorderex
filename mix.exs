defmodule Reorderex.MixProject do
  use Mix.Project

  def project do
    [
      app: :reorderex,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      deps: deps(),
      name: "Reorderex",
      source_url: "https://github.com/cinoss/reorderex"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false},
      {:stream_data, "~> 0.4.3", only: [:test, :dev]},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false}
    ]
  end

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
