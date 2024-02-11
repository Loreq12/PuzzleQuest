extends State
class_name GemSelected

@export var magic_circle: Sprite2D
@export var animation_player: AnimationPlayer

func Enter():
	magic_circle.visible = true
	animation_player.play("selected gem")

func Exit():
	magic_circle.visible = false
	animation_player.stop()
