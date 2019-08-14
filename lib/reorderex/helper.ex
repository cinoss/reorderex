defmodule Reorderex.Helper do
  @moduledoc """
  Reorderex helper functions for manipulating scores.
  """
  @digits '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
  # @digit_to_index @digits
  #                 |> Enum.with_index()
  #                 |> Enum.into(%{})
  # @index_to_digit @digits
  #                 |> Enum.with_index()
  #                 |> Enum.map(fn {a, b} -> {b, a} end)
  #                 |> Enum.into(%{})
  @zero List.first(@digits)
  # @max_digit List.last(@digits)
  @digits_len length(@digits)
  @middle_digit Enum.at(@digits, div(@digits_len, 2))

  @doc """
  Returns a string that is greater than the first argument and smaller than the second argument.

  ## Examples

      iex> Reorderex.Helper.between("a", "c")
      "b"

      iex> Reorderex.Helper.between("c", "a")
      "b"

      iex> Reorderex.Helper.between("a", "b")
      "aV"

      iex> Reorderex.Helper.between("a", "a")
      "a"

      iex> Reorderex.Helper.between(nil, "a")
      "Y"

      iex> Reorderex.Helper.between("0", nil)
      "3"

      iex> Reorderex.Helper.between(nil, nil)
      nil

  """
  @spec between(binary() | nil, binary() | nil) :: binary() | nil
  def between(a, b) do
    between!(a, b)
  rescue
    _e in ArgumentError -> a
  end

  @doc """
  Behaves the same as `between/2` except that it will raise when the two strings are equals.

  ## Examples

      iex> Reorderex.Helper.between!("a", "c")
      "b"

      iex> Reorderex.Helper.between!("a", "a0")
      ** (ArgumentError) Given strings are equals

  """
  @spec between!(binary() | nil, binary() | nil) :: binary() | nil | no_return
  def between!(nil, nil), do: nil

  def between!(nil, b) when is_binary(b) do
    b_charlist = b |> to_charlist

    1..5
    |> Enum.reduce([], fn _, acc ->
      charlist_between!(acc, b_charlist)
    end)
    |> to_string
  end

  def between!(a, nil) when is_binary(a) do
    res = charlist_between!(a |> to_charlist, next_score() |> to_charlist)
    res |> to_string
  end

  def between!(a, b) when is_binary(a) and is_binary(b) do
    [a, b] = if a > b, do: [b, a], else: [a, b]

    res = charlist_between!(a |> to_charlist, b |> to_charlist)
    res |> to_string
  end

  defp charlist_between!([fa | ra] = a, [fb | rb]) do
    if fa == fb do
      [fa | charlist_between!(ra, rb)]
    else
      pa = @digits |> Enum.find_index(&(&1 == fa))
      pb = @digits |> Enum.find_index(&(&1 == fb))
      # pa = @digit_to_index[fa]
      # pb = @digit_to_index[fb]

      if pa + 1 < pb do
        [@digits |> Enum.at(div(pa + pb, 2))]
      else
        # pa + 1 == pb
        a ++ [@middle_digit]
      end
    end
  end

  defp charlist_between!([], [_ | _] = b), do: charlist_between!([@zero], b)

  defp charlist_between!([], []) do
    raise ArgumentError, message: "Given strings are equals"
  end

  @doc false
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

  @doc false
  defp convert(num), do: convert_acc(num, [])

  defp convert_acc(0, acc), do: acc

  defp convert_acc(r, acc),
    do: convert_acc(div(r, @digits_len), [@digits |> Enum.at(rem(r, @digits_len)) | acc])

  @doc """
  Returns current EPOCH in base 62.
  """
  def next_score(_count \\ 1) do
    System.monotonic_time(:microsecond) |> convert() |> to_string
  end
end
