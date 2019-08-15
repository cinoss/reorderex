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
  Return strictly monotonic timestamp if a Clock genserver is given or Reorderex.Clock is
  started as module name. Returns OS time otherwise.
  """
  def next_tick(server \\ nil) do
    server_id =
      cond do
        is_atom(server) -> Process.whereis(server)
        is_pid(server) -> server
        true -> nil
      end

    should_call = if server, do: server_id, else: Process.whereis(__MODULE__)

    if should_call do
      GenServer.call(server || __MODULE__, {:next_tick})
    else
      System.os_time(:microsecond)
    end
  end

  ## Defining GenServer Callbacks

  @impl true
  def init(:ok) do
    {:ok, %{last_tick: 0}}
  end

  @impl true
  def handle_call({:next_tick}, _from, %{last_tick: last_tick}) do
    tick = max(System.os_time(:microsecond), last_tick + 1)
    true = last_tick < tick
    {:reply, tick, %{last_tick: tick}}
  end
end
