defmodule Reorderex.TestMigration do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:photos) do
      add(:score, :string)
    end
  end
end
