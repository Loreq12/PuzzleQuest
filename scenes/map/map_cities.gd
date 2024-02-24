extends Control

@export var current_city: MapCity
var selected_city: MapCity = null
var city_graph := AStar2D.new()


func _ready():
	for child in get_children():
		if child is MapCity:
			city_graph.add_point(child.get_index(), child.position)
	for child in get_children():
		for neighbour in child.neighbours:
			city_graph.connect_points(child.get_index(), neighbour.get_index())
			
func _draw():
	var selected_path_width: int = 3
	var path: Array = []
	if selected_city:
		path = city_graph.get_point_path(current_city.get_index(), selected_city.get_index())
	for city in get_children():
		for neighbour in city.neighbours:
			if path:
				if path.has(city.position) and path.has(neighbour.position):
					selected_path_width = 6
				else:
					selected_path_width = 3
			else:
					selected_path_width = 3

			draw_line(city.position, neighbour.position, Color.BLACK, selected_path_width)


func _on_city_highlight(city: MapCity):
	if city == current_city:
		return
	
	selected_city = city
	queue_redraw()
	#print(city_graph.get_point_path(current_city.get_index(), city.get_index()))


func _on_city_left(city: MapCity):
	selected_city = null
	queue_redraw()
