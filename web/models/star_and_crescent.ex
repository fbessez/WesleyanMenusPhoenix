### Star & Crescent
### I could just grab the whole week at once
defmodule StarandCrescent.Menu do
	import Common
	def get_body do
		url = "http://wesleying.org/author/star-and-crescent/"
		Common.get_body(url)
		|> find_correct_post
		|> scrape_menu_items
		# |> Floki.find(".entry-content")
		# |> Floki.raw_html
	end

	def find_correct_post(found_floki) when length(found_floki) == 0, do: false
	def find_correct_post(found_floki) do
		case (hd found_floki) do
			{"a", [{"href", ""}], [{"i", [{"class", ""}], []}]} -> find_correct_post((tl found_floki))
			{"a", [{"href", ""}], []} -> find_correct_post((tl found_floki))
			_ -> 
				curr = hd found_floki
				title = hd(elem(curr, 2))
				case title =~ "Star and Crescent Menu" do
					true -> 
						Floki.attribute(curr, "href")
						|> hd()
					_ -> find_correct_post(tl found_floki)
				end
		end
	end

	def scrape_menu_items(false), do: "Sorry couldn't find the menu. Check out \"http://wesleying.org/author/star-and-crescent/\""
	def scrape_menu_items(url) do
		IO.puts url
		# IO.puts "Not Yet Implemented"
		{:ok, res} = HTTPoison.get(url, [])
		res.body
		|> Floki.parse()
		|> Floki.find("div, .entry-content")
		|> Floki.filter_out("div p img")
		|> Floki.raw_html
	end
end

# IO.inspect StarandCrescent.Menu.get_body()
