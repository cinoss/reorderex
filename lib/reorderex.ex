defmodule Reorderex do
  @moduledoc """
  Documentation for Reorderex.
  """

  @digits '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
  @zero List.first(@digits)
  # @max_digit List.last(@digits)
  @digits_len length(@digits)

  @doc """
  Between.

  ## Examples

      iex> Reorderex.between("a", "c")
      "b"

      iex> Reorderex.between("a", "a")
      "a"

  """
  def between(a, b) when is_binary(a) and is_binary(b) do
    try do
      between!(a |> to_charlist, b |> to_charlist)
      |> to_string
    rescue
      _e in ArgumentError -> a
    end
  end

  def between!([fa | ra] = a, [fb | rb]) do
    if fa == fb do
      [fa | between!(ra, rb)]
    else
      pa = @digits |> Enum.find_index(&(&1 == fa))
      pb = @digits |> Enum.find_index(&(&1 == fb))

      cond do
        pa + 1 < pb ->
          [@digits |> Enum.at(div(pa + pb, 2))]

        pa + 1 == pb ->
          a ++ [Enum.at(@digits, div(@digits_len, 2))]
          # [fa | between!(ra, [@max_digit])]
      end
    end
  end

  def between!([], [_ | _] = b), do: between!([@zero], b)
  def between!([_ | _] = a, []), do: between!(a, [@zero])

  def between!([], []) do
    raise ArgumentError, message: "Given numbers are equals"
  end

  def filter(s) do
    s
    |> to_charlist()
    |> Enum.filter(&(&1 in @digits))
    |> Enum.reverse()
    |> Enum.reduce([], fn el, acc ->
      if not Enum.empty?(acc) or el != Enum.at(@digits, 0) do
        [el | acc]
      else
        acc
      end
    end)
    |> to_string()
  end

  @doc """
  Convert.

  ## Examples

      iex> Reorderex.convert(62)
      '10'

  """

  def convert(num), do: convert_acc(num, [])

  defp convert_acc(0, acc), do: acc

  defp convert_acc(r, acc),
    do: convert_acc(div(r, @digits_len), [@digits |> Enum.at(rem(r, @digits_len)) | acc])

  def next_index(_count \\ 1) do
    :os.system_time(:millisecond) |> convert |> to_string
  end
end
