defmodule Reorderex.Clock do
  @moduledoc """
  Strictly monotonic clock.
  """

  use GenServer
  ## Client API

  @doc """
  Starts the clock.
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: __MODULE__])
  end

  @doc """
  Get strictly monotonic timestamp.
  """
  def next_tick do
    GenServer.call(__MODULE__, {:next_tick})
  end

  ## Defining GenServer Callbacks

  @impl true
  def init(:ok) do
    {:ok, %{last_tick: 0}}
  end

  @impl true
  def handle_call({:next_tick}, _from, %{last_tick: last_tick}) do
    tick = max(System.os_time(:microsecond), last_tick + 1)

    {:reply, tick, %{last_tick: tick}}
  end
end
