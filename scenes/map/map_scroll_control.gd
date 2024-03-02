extends TextureRect

var scroll_direction : Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ONE * 5

@onready var context_menu: MapCityContextMenu = $ContextMenu

func _process(_delta):
	# Negative direction as you're moving plane, not a camera
	var target_move: Vector2 = -scroll_direction * velocity
	var target_position: Vector2 = position + target_move
	
	if target_position.x > 0 or target_position.y > 0:
		return
	if abs(target_position.x) + get_viewport_rect().size.x > get_rect().size.x:
		return
	if abs(target_position.y) + get_viewport_rect().size.y > get_rect().size.y:
		return
	
	position += target_move


func show_context_menu(city: MapCity):
	context_menu.visible = true
	context_menu.redraw_menu(city)


func hide_context_menu():
	context_menu.visible = false


func scroll_map_left_mouse_entered():
	scroll_direction = Vector2.LEFT


func scroll_map_right_mouse_entered():
	scroll_direction = Vector2.RIGHT


func scroll_map_down_mouse_entered():
	scroll_direction = Vector2.DOWN


func scroll_map_up_mouse_entered():
	scroll_direction = Vector2.UP


func scroll_map_mouse_exited():
	scroll_direction = Vector2.ZERO
