extends Control
class_name MapCity

@export var neighbours: Array[MapCity] = []

@export_subgroup("Context Menu")
@export var your_citadel: bool
@export var missions: bool
@export var tavern: bool
@export var shop: bool
@export var equipment: bool

signal city_highlight(city: MapCity)
signal city_left()
signal city_selected(city: MapCity)

func _ready():
	$Label.text = self.name
	
func disable_interation():
	$Collider.set_pickable(false)

func enable_interation():
	$Collider.set_pickable(true)

func _on_collider_mouse_entered():
	city_highlight.emit(self)

func _on_collider_mouse_exited():
	city_left.emit()

func _on_collider_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			city_selected.emit(self)
