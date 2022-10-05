defmodule NalkaOnPitkaApi.Cache do
  @moduledoc """
  A simple ETS based cache for expensive function calls.
  """
  use GenServer

  @table __MODULE__

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    :ets.new(@table, [:set, :protected, :named_table])

    {:ok, opts}
  end

  @doc """
  Retrieve a cached value or apply the given function caching and returning
  the result.
  """
  def get(mod, fun, args \\ []) do
    case lookup(mod, fun, args) do
      nil ->
        cache_apply(mod, fun, args)

      result ->
        result
    end
  end

  # Lookup a cached result and check the freshness
  defp lookup(mod, fun, args) do
    case :ets.lookup(@table, [mod, fun, args]) do
      [result | _] -> check_freshness(result)
      [] -> nil
    end
  end

  # Compare the result expiration against the current system time.
  defp check_freshness({_mfa, result, {year, week}}) do
    {current_year, current_week} = Timex.iso_week(Timex.now())
    cond do
      current_year != year -> nil
      current_week != week -> nil
      true -> result
    end
  end

  # Apply the function, calculate expiration, and cache the result.
  defp cache_apply(mod, fun, args) do
    result = apply(mod, fun, args)
    GenServer.cast(__MODULE__, {:put, {[mod, fun, args], result, Timex.iso_week(Timex.now())}})
    result
  end

  @impl true
  def handle_cast({:put, value}, state) do
    :ets.insert(@table, value)
    {:noreply, state}
  end
end
