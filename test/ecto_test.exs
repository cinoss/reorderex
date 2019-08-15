defmodule Reorderex.EctoTest do
  @moduledoc false
  use Reorderex.DataCase, async: true

  defmodule Photo do
    @moduledoc false
    use Ecto.Schema

    schema "photos" do
      field(:score, :binary, autogenerate: {Reorderex, :next_score, []})
    end
  end

  alias Reorderex.TestRepo, as: Repo
  import Ecto.Query

  def get_all_ids do
    Photo
    |> order_by(:score)
    |> Repo.all()
    |> Enum.map(& &1.id)
  end

  describe "ecto" do
    test "123" do
      photo1 = Repo.insert!(%Photo{score: Reorderex.next_score()})
      photo2 = Repo.insert!(%Photo{score: Reorderex.next_score()})
      photo3 = Repo.insert!(%Photo{score: Reorderex.next_score()})

      assert get_all_ids() == [photo1.id, photo2.id, photo3.id]

      photo3
      |> Reorderex.Ecto.insert_after(photo1.id, Repo)
      |> Repo.update()

      assert get_all_ids() == [photo1.id, photo3.id, photo2.id]

      photo3
      |> Reorderex.Ecto.insert_after(nil, Repo)
      |> Repo.update()

      assert get_all_ids() == [photo3.id, photo1.id, photo2.id]
    end

    test "move to last" do
      photo1 = Repo.insert!(%Photo{score: Reorderex.next_score()})
      photo2 = Repo.insert!(%Photo{score: Reorderex.next_score()})
      photo3 = Repo.insert!(%Photo{score: Reorderex.next_score()})

      assert get_all_ids() == [photo1.id, photo2.id, photo3.id]

      photo2
      |> Reorderex.Ecto.insert_after(photo3.id, Repo)
      |> Repo.update()

      assert get_all_ids() == [photo1.id, photo3.id, photo2.id]
    end
  end
end
