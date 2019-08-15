defmodule Reorderex.ClockTest do
  @moduledoc false
  use ExUnit.Case

  describe "next_tick" do
    test "should work without a genserver running" do
      Reorderex.Clock.next_tick(:dummy)
    end

    test "should be strictly monotonic with default clock" do
      1..1000
      |> Enum.reduce(0, fn idx, acc ->
        tick = Reorderex.Clock.next_tick()
        assert {idx, acc} < {idx, tick}
        tick
      end)
    end

    test "should be strictly monotonic with new clock given" do
      {:ok, clock} = Reorderex.Clock.start_link(name: :clock)

      1..1000
      |> Enum.reduce(0, fn idx, acc ->
        tick = Reorderex.Clock.next_tick(clock)
        assert {idx, acc} < {idx, tick}
        tick
      end)

      1..1000
      |> Enum.reduce(0, fn idx, acc ->
        tick = Reorderex.Clock.next_tick(:clock)
        assert {idx, acc} < {idx, tick}
        tick
      end)

      GenServer.stop(clock)
    end
  end
end
