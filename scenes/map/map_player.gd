extends Sprite2D

@export var current_city: MapCity


func _ready():
	position = current_city.position
