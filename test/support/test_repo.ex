defmodule Reorderex.TestRepo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :reorderex,
    adapter: Ecto.Adapters.Postgres
end
