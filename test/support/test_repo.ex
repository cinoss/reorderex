defmodule Reorderex.TestRepo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :reorderex,
    adapter: Ecto.Adapters.Postgres

  # def log(_cmd), do: nil
end
