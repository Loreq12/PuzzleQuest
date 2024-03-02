extends Camera2D

@onready var world_map: TextureRect = $"../WorldMap"
func _input(event):
	if event is InputEventMouseMotion:
		var viewport_size = get_viewport_rect().size
		if event.position.x < 100:
			world_map.scroll_map_left_mouse_entered()
		elif event.position.y < 100:
			world_map.scroll_map_up_mouse_entered()
		elif event.position.x > viewport_size.x - 100:
			world_map.scroll_map_right_mouse_entered()
		elif event.position.y > viewport_size.y - 100:
			world_map.scroll_map_down_mouse_entered()
		else:
			world_map.scroll_map_mouse_exited()
