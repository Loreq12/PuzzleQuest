extends TextureRect

var scroll_direction : Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ONE * 5

func _process(delta):
	# Negative direction as you're moving plane, not a camera
	var target_move: Vector2 = -scroll_direction * velocity
	var target_position: Vector2 = position + target_move
	
	if target_position.x > 0 or target_position.y > 0:
		return
	if abs(target_position.x) + get_window().size.x > get_rect().size.x:
		return
	if abs(target_position.y) + get_window().size.y > get_rect().size.y:
		return
	
	position += target_move


func _on_scroll_map_left_mouse_entered():
	scroll_direction = Vector2.LEFT


func _on_scroll_map_right_mouse_entered():
	scroll_direction = Vector2.RIGHT


func _on_scroll_map_down_mouse_entered():
	scroll_direction = Vector2.DOWN


func _on_scroll_map_up_mouse_entered():
	scroll_direction = Vector2.UP


func _on_scroll_map_mouse_exited():
	scroll_direction = Vector2.ZERO
