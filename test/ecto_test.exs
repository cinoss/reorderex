defmodule Reorderex.EctoTest do
  @moduledoc false
  use Reorderex.DataCase, async: true

  defmodule Photo do
    @moduledoc false
    use Ecto.Schema

    schema "photos" do
      field(:score, :binary, autogenerate: {Reorderex, :next_index, []})
    end
  end

  alias Reorderex.TestRepo, as: Repo
  import Ecto.Query

  describe "ecto" do
    test "123" do
      photo1 = Repo.insert!(%Photo{})
      photo2 = Repo.insert!(%Photo{})
      photo3 = Repo.insert!(%Photo{})

      assert Photo
             |> order_by(:score)
             |> Repo.all()
             |> Enum.map(& &1.id) == [photo1.id, photo2.id, photo3.id]

      photo3
      |> Reorderex.Ecto.insert_after(photo1.id, Repo)
      |> Repo.update()

      assert Photo
             |> order_by(:score)
             |> Repo.all()
             |> Enum.map(& &1.id) == [photo1.id, photo3.id, photo2.id]

      photo3
      |> Reorderex.Ecto.insert_after(nil, Repo)
      |> Repo.update()

      assert Photo
             |> order_by(:score)
             |> Repo.all()
             |> Enum.map(& &1.id) == [photo3.id, photo1.id, photo2.id]
    end

    test "move to last" do
      photo1 = Repo.insert!(%Photo{})
      photo2 = Repo.insert!(%Photo{})
      photo3 = Repo.insert!(%Photo{})

      photo2
      |> Reorderex.Ecto.insert_after(photo3.id, Repo)
      |> Repo.update()

      assert Photo
             |> order_by(:score)
             |> Repo.all()
             |> Enum.map(& &1.id) == [photo1.id, photo3.id, photo2.id]
    end
  end
end
