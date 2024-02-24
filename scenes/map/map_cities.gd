@tool
extends Control

@onready var cities_graph: MapGraph = $"../../CitiesGraph"


func _process(delta):
	if Engine.is_editor_hint():
		queue_redraw()
	#print("kurwa")
	#draw.emit()

func _draw():
	for city in cities_graph.nodes.values():
		draw_circle(city.position, 25, Color.CORNFLOWER_BLUE)
