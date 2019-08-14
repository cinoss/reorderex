import Mix.Config

config :reorderex,
  ecto_repos: [Reorderex.TestRepo]

config :reorderex, Reorderex.TestRepo,
  adapter: Ecto.Adapters.Postgres,
  url: "ecto://postgres@localhost/ecto_test",
  pool: Ecto.Adapters.SQL.Sandbox

# config :logger, handle_sasl_reports: true

# config :reorderex, Ecto.Integration.TestRepo,
#   adapter: Ecto.Adapters.Postgres,
#   url: "ecto://postgres@localhost/ecto_test",
#   pool: Ecto.Adapters.SQL.Sandbox
