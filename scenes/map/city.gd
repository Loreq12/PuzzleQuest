extends Control
class_name MapCity

@export var neighbours: Array[MapCity] = []

signal city_highlight(city: MapCity)
signal city_left(city: MapCity)

func _on_collider_mouse_entered():
	city_highlight.emit(self)


func _on_collider_mouse_exited():
	city_left.emit(self)
