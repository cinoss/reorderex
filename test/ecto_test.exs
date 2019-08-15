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

  def get_all_photos, do: Photo |> order_by(:score) |> Repo.all()

  def get_all_ids, do: get_all_photos() |> Enum.map(& &1.id)

  describe "ecto" do
    test "123" do
      1..3
      |> Enum.each(fn _ ->
        Repo.insert!(%Photo{})
      end)

      [photo1, photo2, photo3] = get_all_photos()

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
      1..3
      |> Enum.each(fn _ ->
        Repo.insert!(%Photo{})
      end)

      [photo1, photo2, photo3] = get_all_photos()

      photo2
      |> Reorderex.Ecto.insert_after(photo3.id, Repo)
      |> Repo.update()

      assert get_all_ids() == [photo1.id, photo3.id, photo2.id]
    end
  end
end
