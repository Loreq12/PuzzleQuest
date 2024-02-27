@tool
extends Sprite2D

@export var current_city: MapCity


func _ready():
	position = current_city.position

func _process(delta):
	if Engine.is_editor_hint():
		position = current_city.position
