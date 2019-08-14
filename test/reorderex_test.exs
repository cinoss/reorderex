defmodule ReorderexTest do
  @moduledoc false

  use ExUnit.Case
  use ExUnitProperties

  doctest Reorderex

  describe "filter/1" do
    test "abc" do
      assert Reorderex.Helper.filter("abc00") == "abc"
      assert Reorderex.Helper.filter("abc000") == Reorderex.Helper.filter("abc00")
    end
  end

  describe "between/2" do
    test "should produce result that stays in between" do
      check all(
              a <- StreamData.string(:ascii, max_length: 10),
              b <- StreamData.string(:ascii, max_length: 10),
              max_run: 1000
            ) do
        a = Reorderex.Helper.filter(a)
        b = Reorderex.Helper.filter(b)

        if a != b do
          avg = Reorderex.Helper.between(a, b)

          [a, b] = if a > b, do: [b, a], else: [a, b]

          assert a < avg
          assert avg < b
          assert String.length(avg) <= max(String.length(a), String.length(b)) + 1
        else
          avg = Reorderex.Helper.between(a, b)

          assert a == avg
          assert avg == b
        end
      end
    end

    test "should survive edge cases" do
      for [a, b] <- [
            ["", "K"],
            ["Jh", "K"],
            ["Jz", "K"],
            ["a", "a1"],
            ["a", "a01"],
            ["0", "0011"],
            [nil, "a01"],
            ["0", nil]
          ] do
        avg = Reorderex.Helper.between(a, b)

        assert (a || "") < avg
        assert avg < (b || Reorderex.next_score())

        assert String.length(avg) <=
                 max(String.length(a || ""), String.length(b || Reorderex.next_score())) + 1
      end
    end

    test "should not increase in length so rapidly" do
      times = 5000

      assert times / 30 + 1 >=
               1..times
               |> Enum.reduce(Reorderex.next_score(), fn _, acc ->
                 Reorderex.Helper.between(nil, acc)
               end)
               |> String.length()
    end
  end

  describe "next_score/1" do
    test "should be increasing" do
      a = Reorderex.next_score()
      b = Reorderex.next_score()
      assert a < b
      assert is_binary(a)
      assert is_binary(b)
    end
  end
end
