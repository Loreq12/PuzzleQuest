extends State
class_name GemDestroyed

@export var gem: Sprite2D
@export var particles: CPUParticles2D

func Enter():
	print("BURN TO THE GROUD")
	gem.visible = false
	particles.emitting = true
