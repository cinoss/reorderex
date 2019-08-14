Logger.configure(level: :info)
ExUnit.start()
Ecto.Migrator.up(Reorderex.TestRepo, 0, Reorderex.TestMigration, log: false)
