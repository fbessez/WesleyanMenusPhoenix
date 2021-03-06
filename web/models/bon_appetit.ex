defmodule BonAppetit.Fetch do
	@usdan "332"
	@summies "337"
	@usdanurl "http://legacy.cafebonappetit.com/api/2/menus?cafe=#{@usdan}"
	@summiesurl "http://legacy.cafebonappetit.com/api/2/menus?cafe=#{@summies}"

	def fetch_usdan() do
		{:ok, response} = HTTPoison.get(@usdanurl, [])
		secondary(response)
	end

	def fetch_summies() do 
		{:ok, response} = HTTPoison.get(@summiesurl, [])
		secondary(response)
	end

	def secondary(response) do
	    response
	    |> Map.from_struct
	    |> Map.fetch!(:body)
	    |> Poison.decode!
	end
end

defmodule Usdan.Menu do
	@usdan "332"
	@summies "337"
	@body_map BonAppetit.Fetch.fetch_usdan()

	def get_body_map, do: @body_map
	def get_items_index, do: @body_map["items"]

	def get_all_necessary_data() do
		menu = hd (hd get_body_map["days"])["cafes"][@usdan]["dayparts"]
		IO.inspect dayparts(menu, %{})
	end

	#  hd (hd body_map["days"])["cafes"][cafe]["dayparts"] 
	def dayparts(dayparts, map) when length(dayparts) <= 0, do: map
	def dayparts(dayparts, map) do
		curr_daypart = hd dayparts
		daypart_label = curr_daypart["label"]
		daypart_stations = curr_daypart["stations"]
		map = Map.put(map, daypart_label, stations(daypart_stations, %{}))
		dayparts((tl dayparts), map)
	end

	# (hd (hd (hd body_map["days"])["cafes"][cafe]["dayparts"])) ["stations"]
	def stations(stations, map) when length(stations) <= 0, do: map
	def stations(stations, map) do
		curr_station = hd stations
		station = curr_station["label"]
		station_items = get_item_names((curr_station["items"]), [])
		map = Map.put(map, station, station_items)
		stations((tl stations), map)
	end


	def get_item_names(item_list, item_names) when length(item_list) <= 0, do: item_names
	def get_item_names(item_list, item_names) do
		curr_item_no = hd item_list
		item_name = get_item_name(curr_item_no)
		item_names = item_names ++ [item_name]
		get_item_names((tl item_list),item_names)
	end

	def get_item_name(item_no) do
		get_items_index[item_no]["label"]
	end


# Need to somehow store all item numbers and descriptions in config?
# by calling the api?
end

# Usdan.Menu.get_all_necessary_data()





### Bon Appetit

# view-source:http://wesleyan.cafebonappetit.com/cafe/2017-03-27/


### A public API explanation
# http://wesleyan.cafebonappetit.com/wp-json/

#### THESE ONLY DISPLAY ITEM NUMBERS
## DAILY JSON FOR MENU ITEMS AT USDAN
# http://legacy.cafebonappetit.com/api/2/menus?cafe=332
# Marketplace ID = 332

## DAILY JSON FOR MENU ITEMS AT Summies
# http://legacy.cafebonappetit.com/api/2/menus?cafe=337
# Summerfields ID = 337

## Item Query Lookup URL
# http://legacy.cafebonappetit.com/api/2/items?item=4470605

#  https://github.com/wesleyan
# https://trello.com/b/jCd8aDdO/st-olaf-apis
# https://ist.mit.edu/web-api

