@tool
extends Control
class_name MapCity

@export var neighbours: Array[MapCity] = []

signal city_highlight(city: MapCity)
signal city_left(city: MapCity)
signal city_selected(city: MapCity)

func _ready():
	$Label.text = self.name
	
	
func _process(delta):
	if Engine.is_editor_hint():
		$Label.text = self.name


func _on_collider_mouse_entered():
	city_highlight.emit(self)


func _on_collider_mouse_exited():
	city_left.emit(self)


func _on_collider_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			city_selected.emit(self)
