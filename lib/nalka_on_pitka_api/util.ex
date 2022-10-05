defmodule NalkaOnPitkaApi.Util do
  @moduledoc """
  Utility function for crawlers
  """

  @doc """
  Convert list of lunches to map
  """
  @spec to_lunch_map(maybe_improper_list) :: map
  def to_lunch_map(lunches) when is_list(lunches) do
    lunches
    |> Enum.with_index()
    |> Enum.reject(fn {_l, index} -> index >= 7 end)
    |> Enum.map(fn {lunch, index} -> {number_to_date(index), lunch} end)
    |> Map.new()
  end

  @spec number_to_date(0 | 1 | 2 | 3 | 4 | 5 | 6) ::
          :friday | :monday | :saturday | :sunday | :thursday | :tuesday | :wednesday
  def number_to_date(0), do: :monday
  def number_to_date(1), do: :tuesday
  def number_to_date(2), do: :wednesday
  def number_to_date(3), do: :thursday
  def number_to_date(4), do: :friday
  def number_to_date(5), do: :saturday
  def number_to_date(6), do: :sunday
end
