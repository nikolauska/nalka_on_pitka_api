 defmodule NalkaOnPitkaApi.Sites.Harald do
   use NalkaOnPitkaApi.Sites

   @impl true
   def base_url(), do: "https://www.ravintolaharald.fi/jyvaskyla/lounas/"

   @impl true
   def parse_item(response) do
     # Parse response body to document
     {:ok, document} = Floki.parse_document(response.body)

     # Create item (for pages where items exists)
     lunches =
       document
       |> Floki.find("#lunchweek_1")
       |> List.first()
       |> Floki.find(".lounas-menu")
       |> Enum.map(fn x ->
         x
         |> Floki.find("tr")
         |> Enum.map(fn x ->
            x
            |> Floki.find("th")
            |> List.first()
            |> Floki.text()
         end)
       end)
       |> Enum.reject(fn l -> l == [] end)
       |> Enum.map(fn l -> tl(l) end)
       |> NalkaOnPitkaApi.Util.to_lunch_map()

     %Crawly.ParsedItem{items: [lunches], requests: []}
   end
 end
