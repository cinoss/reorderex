defmodule Reorderex do
  @moduledoc """
  An elixir helper library for database list reordering functionality.

  ## Usage with Ecto

  ### Table-wise ordering

  #### Schema
  ```
  defmodule Photo do
    @moduledoc false
    use Ecto.Schema

    schema "photos" do
      field(:score, :binary, autogenerate: {Reorderex, :next_score, []})
    end
  end
  ```

  #### Move and entity to after an entity

  ```
  import Reorderex.Ecto

  photo
  |> insert_after(photo1.id, Repo)
  |> Repo.update()
  ```

  #### Move and entity to the first

  ```
  import Reorderex.Ecto

  photo
  |> insert_after(nil, Repo)
  |> Repo.update()
  ```

  ### Shared-table ordering

  ```
  defmodule Photo do
    @moduledoc false
    use Ecto.Schema

    schema "photos" do
      field user_id, :binary
      field :score, :binary, autogenerate: {Reorderex, :next_score, []}
    end
  end
  ```

  ```
  import Reorderex.Ecto

  query = Photo |> where([p], p.user_id = ^user_id)

  photo
  |> insert_after(photo1.id, Repo, query: query)
  |> Repo.update()
  ```
  """

  alias Reorderex.Helper

  @doc """
  Returns current EPOCH in base 62.
  """
  defdelegate next_score, to: Helper
end
