defmodule Reorderex.Ecto do
  @moduledoc """
  Reorderex.Ecto
  """

  import Ecto.Query

  def insert_after(entity, after_id, repo, opts \\ []) do
    field = opts |> Keyword.get(:field, :score)

    after_entity =
      after_id &&
        entity.__struct__
        |> repo.get(after_id)

    before_entity =
      (opts[:query] || entity.__struct__)
      |> order_by(^field)
      |> (fn q ->
            if after_entity do
              q |> where([e], field(e, ^field) > ^(after_entity |> Map.get(field)))
            else
              q
            end
          end).()
      |> limit(1)
      |> repo.one()

    entity
    |> Ecto.Changeset.cast(
      %{
        field =>
          Reorderex.between(
            after_entity && after_entity |> Map.get(field),
            before_entity && before_entity |> Map.get(field)
          )
      },
      [field]
    )
  end
end
