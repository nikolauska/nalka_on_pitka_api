defmodule NalkaOnPitkaApi.Sites.Cielo do
  use NalkaOnPitkaApi.Sites

  @impl true
  def base_url(), do: "https://www.ravintolacielo.com/lounas"

  @impl true
  def parse_item(response) do
    # Parse response body to document
    {:ok, document} = Floki.parse_document(response.body)

    # Create item (for pages where items exists)
    lunches =
      document
      |> Floki.find("div[data-testid=\"richTextElement\"]")
      |> Enum.at(2, [])
      |> Floki.find("p")
      |> Enum.reduce([], fn p, acc ->
        p
        |> Floki.find("span")
        |> List.first([])
        |> Floki.find("span")
        |> List.first([])
        |> Floki.text()
        |> case do
          "\n" ->
            [[] | acc]

          text when acc == [] ->
            [[text]]

          text ->
            [head | tail] = acc
            [[text | head] | tail]
        end
      end)
      |> get_tail()
      |> Enum.map(fn l -> Enum.reverse(l) |> get_tail() end)
      |> Enum.reverse()
      |> NalkaOnPitkaApi.Util.to_lunch_map()

    %Crawly.ParsedItem{items: [lunches], requests: []}
  end

  defp get_tail([]), do: []
  defp get_tail(list), do: tl(list)
end
