extends State
class_name GemDeselected2

@export var magic_circle: Sprite2D
@export var animation_player: AnimationPlayer

func Enter():
	magic_circle.visible = false
	animation_player.stop()
