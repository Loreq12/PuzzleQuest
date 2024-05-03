extends Control
class_name MapEnemy


func spawn():
	$Appear.emitting = true

func destroy():
	$Sprite2D.visible = false
	$Dissapear.emitting = true
	await $Dissapear.finished
	queue_free()
