defmodule NalkaOnPitkaApi.Sites do
  @moduledoc """
  Get lunches for specified site
  """

  defmacro __using__(_opts) do
    quote location: :keep do
      use Crawly.Spider

      @impl true
      def base_url(), do: ""

      @impl true
      def init() do
        [start_urls: [base_url()]]
      end

      def get() do
        base_url()
        |> Crawly.fetch()
        |> Crawly.parse(__MODULE__)
        |> Map.get(:items, [])
        |> List.first()
      end

      defoverridable base_url: 0
    end
  end

  @sites ["harald", "eden", "cielo"]

  def get_sites() do
    @sites
  end

  @doc """
  Get lunches
  """
  def get(<<head::utf8>> <> rest = str) when str in @sites do
    site = String.to_atom("#{String.upcase(<<head::utf8>>)}#{rest}")
    NalkaOnPitkaApi.Cache.get(Module.concat([NalkaOnPitkaApi, Sites, site]), :get)
  end
end
