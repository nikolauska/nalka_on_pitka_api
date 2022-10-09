 defmodule NalkaOnPitkaApi.Sites.Eden do
   use NalkaOnPitkaApi.Sites

   @impl true
   def base_url(), do: "https://viherlandia.fi/eeden/lounaslista/"

   @impl true
   def parse_item(response) do
     # Parse response body to document
     {:ok, document} = Floki.parse_document(response.body)

     {_year, week} = Timex.now() |> Timex.iso_week()

     # Create item (for pages where items exists)
     lunches =
       document
       |> Floki.find("#lunch-menu-#{week}")
       |> List.first([])
       |> Floki.find("ul")
       |> Enum.map(fn ul ->
         ul
         |> Floki.find("li")
         |> Enum.map(fn li -> Floki.text(li) end)
       end)
       |> NalkaOnPitkaApi.Util.to_lunch_map()

     %Crawly.ParsedItem{items: [lunches], requests: []}
   end
 end
