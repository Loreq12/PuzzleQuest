@tool
extends Control

@onready var cities_graph: MapGraph = $"../../CitiesGraph"


func _process(delta):
	if Engine.is_editor_hint():
		print(cities_graph.get_edges())
		queue_redraw()

func _draw():
	var edges: Dictionary = cities_graph.get_edges()
	for city in edges:
		for target in edges[city]:
			draw_line(city.position, target.position, Color.BLACK, 5)

	for city in cities_graph.nodes.values():
		if not city.visible:
			continue
		draw_circle(city.position, 25, Color.CORNFLOWER_BLUE)
