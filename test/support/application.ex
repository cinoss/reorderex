defmodule Reorderex.TestApplication do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Reorderex.TestRepo,
      Reorderex.Clock
    ]

    opts = [strategy: :one_for_one, name: Reorderex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
